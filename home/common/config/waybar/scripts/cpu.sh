#!/bin/bash

# CPU Monitor Script for Polybar/Waybar
# Dynamically detects actual CPU topology including Intel hybrid architectures

get_cpu_info() {
    local vendor=""
    local total_cores=0

    if [[ -f /proc/cpuinfo ]]; then
        vendor=$(grep -m1 "vendor_id" /proc/cpuinfo | awk '{print $3}')
        total_cores=$(grep "^processor" /proc/cpuinfo | wc -l)
    else
        total_cores=$(nproc)
    fi

    echo "$vendor $total_cores"
}

get_ccd_config() {
    local -A die_cores
    local -a dies
    local cpu_info vendor total_cores

    cpu_info=$(get_cpu_info)
    vendor=$(echo "$cpu_info" | awk '{print $1}')

    if [[ "$vendor" == "GenuineIntel" ]]; then
        local -A freq_groups
        local -a sorted_freqs

        for cpu_dir in /sys/devices/system/cpu/cpu[0-9]*; do
            if [[ -f "$cpu_dir/cpufreq/cpuinfo_max_freq" ]]; then
                local cpu_num max_freq freq_mhz freq_group
                cpu_num=$(basename "$cpu_dir" | sed 's/cpu//')
                max_freq=$(cat "$cpu_dir/cpufreq/cpuinfo_max_freq" 2>/dev/null)

                if [[ "$max_freq" =~ ^[0-9]+$ ]]; then
                    freq_mhz=$((max_freq / 1000))
                    freq_group=$((freq_mhz / 100 * 100))

                    if [[ -z "${freq_groups[$freq_group]}" ]]; then
                        freq_groups[$freq_group]="$cpu_num"
                    else
                        freq_groups[$freq_group]+=" $cpu_num"
                    fi
                fi
            fi
        done

        sorted_freqs=($(printf '%s\n' "${!freq_groups[@]}" | sort -rn))

        local group_id=0
        for freq in "${sorted_freqs[@]}"; do
            dies+=("$group_id")
            die_cores[$group_id]="${freq_groups[$freq]}"
            ((group_id++))
        done
    fi

    if [[ ${#dies[@]} -eq 0 ]] && [[ -d /sys/devices/system/cpu ]]; then
        for cpu_dir in /sys/devices/system/cpu/cpu[0-9]*; do
            if [[ -f "$cpu_dir/topology/die_id" ]]; then
                local cpu_num die_id
                cpu_num=$(basename "$cpu_dir" | sed 's/cpu//')
                die_id=$(cat "$cpu_dir/topology/die_id" 2>/dev/null)

                if [[ "$die_id" =~ ^[0-9]+$ ]]; then
                    if [[ -z "${die_cores[$die_id]}" ]]; then
                        die_cores[$die_id]="$cpu_num"
                        dies+=("$die_id")
                    else
                        die_cores[$die_id]+=" $cpu_num"
                    fi
                fi
            fi
        done
    fi

    if [[ ${#dies[@]} -eq 0 ]]; then
        for cpu_dir in /sys/devices/system/cpu/cpu[0-9]*; do
            if [[ -f "$cpu_dir/topology/physical_package_id" ]]; then
                local cpu_num pkg_id
                cpu_num=$(basename "$cpu_dir" | sed 's/cpu//')
                pkg_id=$(cat "$cpu_dir/topology/physical_package_id" 2>/dev/null)

                if [[ "$pkg_id" =~ ^[0-9]+$ ]]; then
                    if [[ -z "${die_cores[$pkg_id]}" ]]; then
                        die_cores[$pkg_id]="$cpu_num"
                        dies+=("$pkg_id")
                    else
                        die_cores[$pkg_id]+=" $cpu_num"
                    fi
                fi
            fi
        done
    fi

    if [[ ${#dies[@]} -eq 0 ]] && [[ "$vendor" == "AuthenticAMD" ]]; then
        local -A l3_cores
        local -a l3_groups

        for cpu_dir in /sys/devices/system/cpu/cpu[0-9]*; do
            local cpu_num l3_cache_dir shared_cpus found_group
            cpu_num=$(basename "$cpu_dir" | sed 's/cpu//')
            l3_cache_dir="$cpu_dir/cache/index3"

            if [[ -f "$l3_cache_dir/shared_cpu_list" ]]; then
                shared_cpus=$(cat "$l3_cache_dir/shared_cpu_list" 2>/dev/null)
                found_group=""

                for group in "${l3_groups[@]}"; do
                    if [[ "${l3_cores[$group]}" == "$shared_cpus" ]]; then
                        found_group="$group"
                        break
                    fi
                done

                if [[ -z "$found_group" ]]; then
                    local group_id=${#l3_groups[@]}
                    l3_groups+=("$group_id")
                    l3_cores[$group_id]="$shared_cpus"
                fi
            fi
        done

        for group in "${l3_groups[@]}"; do
            local shared_list core_list
            shared_list="${l3_cores[$group]}"
            core_list=$(echo "$shared_list" | tr ',' ' ' | sed 's/-/ /g' | tr -s ' ')
            die_cores[$group]="$core_list"
            dies+=("$group")
        done
    fi

    if [[ ${#dies[@]} -eq 0 ]]; then
        total_cores=$(echo "$cpu_info" | awk '{print $2}')

        if [[ $total_cores -le 8 ]]; then
            dies=("0")
            die_cores[0]=$(seq -s' ' 0 $((total_cores - 1)))
        else
            local mid=$((total_cores / 2))
            dies=("0" "1")
            die_cores[0]=$(seq -s' ' 0 $((mid - 1)))
            die_cores[1]=$(seq -s' ' $mid $((total_cores - 1)))
        fi
    fi

    if [[ "$vendor" != "GenuineIntel" ]] || [[ ${#dies[@]} -le 1 ]]; then
        IFS=$'\n' dies=($(sort -n <<<"${dies[*]}"))
        unset IFS
    fi

    echo "${#dies[@]}"
    for die in "${dies[@]}"; do
        echo "$die:${die_cores[$die]}"
    done
}

get_ccd_load() {
    local cores="$1"
    local total_load=0
    local core_count=0
    local -A target_cores

    for core in $cores; do
        target_cores[$core]=1
    done

    while read -r line; do
        if [[ $line =~ ^cpu([0-9]+)[[:space:]] ]]; then
            local cpu_num="${BASH_REMATCH[1]}"

            if [[ ${target_cores[$cpu_num]} ]]; then
                local fields user nice system idle iowait irq softirq steal total work prev_file prev_total prev_work load
                fields=($line)
                user=${fields[1]:-0}
                nice=${fields[2]:-0}
                system=${fields[3]:-0}
                idle=${fields[4]:-0}
                iowait=${fields[5]:-0}
                irq=${fields[6]:-0}
                softirq=${fields[7]:-0}
                steal=${fields[8]:-0}

                if [[ "$user" =~ ^[0-9]+$ ]] && [[ "$idle" =~ ^[0-9]+$ ]]; then
                    total=$(awk "BEGIN {print $user + $nice + $system + $idle + $iowait + $irq + $softirq + $steal}")
                    work=$(awk "BEGIN {print $total - $idle}")

                    prev_file="/tmp/cpu_monitor_${cpu_num}"
                    prev_total=0
                    prev_work=0

                    if [[ -f "$prev_file" ]]; then
                        local prev_data
                        prev_data=$(cat "$prev_file" 2>/dev/null)
                        if [[ "$prev_data" =~ ^([0-9.]+)[[:space:]]+([0-9.]+)$ ]]; then
                            prev_total="${BASH_REMATCH[1]}"
                            prev_work="${BASH_REMATCH[2]}"
                        fi
                    fi

                    echo "$total $work" > "$prev_file"

                    load=0
                    if [[ -n "$prev_total" ]] && [[ "$prev_total" != "0" ]]; then
                        load=$(awk "BEGIN {
                            total_diff = $total - $prev_total;
                            work_diff = $work - $prev_work;
                            if (total_diff > 0) {
                                load = work_diff * 100 / total_diff;
                                if (load < 0) load = 0;
                                if (load > 100) load = 100;
                                printf \"%.0f\", load;
                            } else {
                                print 0;
                            }
                        }")
                    fi

                    if [[ "$load" =~ ^[0-9]+$ ]]; then
                        total_load=$(awk "BEGIN {print $total_load + $load}")
                        core_count=$((core_count + 1))
                    fi
                fi
            fi
        fi
    done < /proc/stat

    if [[ $core_count -gt 0 ]]; then
        awk "BEGIN {printf \"%.0f\", $total_load / $core_count}"
    else
        echo 0
    fi
}

get_total_freq() {
    local total_freq=0
    local core_count=0
    local freq

    for freq_file in /sys/devices/system/cpu/cpu*/cpufreq/cpuinfo_cur_freq; do
        if [[ -r "$freq_file" ]]; then
            freq=$(cat "$freq_file" 2>/dev/null)
            if [[ "$freq" =~ ^[0-9]+$ ]] && [[ $freq -gt 0 ]]; then
                total_freq=$(awk "BEGIN {print $total_freq + $freq}")
                core_count=$((core_count + 1))
            fi
        fi
    done

    if [[ $core_count -eq 0 ]]; then
        for freq_file in /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq; do
            if [[ -r "$freq_file" ]]; then
                freq=$(cat "$freq_file" 2>/dev/null)
                if [[ "$freq" =~ ^[0-9]+$ ]] && [[ $freq -gt 0 ]]; then
                    total_freq=$(awk "BEGIN {print $total_freq + $freq}")
                    core_count=$((core_count + 1))
                fi
            fi
        done
    fi

    if [[ $core_count -eq 0 ]] && [[ -f /proc/cpuinfo ]]; then
        local cpu_mhz
        cpu_mhz=$(grep -m1 "cpu MHz" /proc/cpuinfo | awk '{print $4}' 2>/dev/null)
        if [[ "$cpu_mhz" =~ ^[0-9]+\.?[0-9]*$ ]] && [[ $(awk "BEGIN {print ($cpu_mhz > 0)}") -eq 1 ]]; then
            total_freq=$(awk "BEGIN {print $cpu_mhz * 1000}")
            core_count=1
        fi
    fi

    if [[ $core_count -gt 0 ]]; then
        awk "BEGIN {printf \"%.2f\", $total_freq / $core_count / 1000000}"
    else
        echo "0.00"
    fi
}

get_cpu_temp() {
    local temp=""
    local cpu_info vendor name raw_temp
    cpu_info=$(get_cpu_info)
    vendor=$(echo "$cpu_info" | awk '{print $1}')

    if command -v sensors >/dev/null 2>&1; then
        case "$vendor" in
            "AuthenticAMD")
                temp=$(sensors 2>/dev/null | grep -i "tctl" | head -1 | grep -oE '[0-9]+\.?[0-9]*' | head -1)
                if [[ -z "$temp" ]]; then
                    temp=$(sensors 2>/dev/null | grep -i "cpu temp\|k10temp\|zenpower" | head -1 | grep -oE '[0-9]+\.?[0-9]*' | head -1)
                fi
                ;;
            "GenuineIntel")
                temp=$(sensors 2>/dev/null | grep -E "Core 0|Package id 0|CPU" | head -1 | grep -oE '[0-9]+\.?[0-9]*' | head -1)
                if [[ -z "$temp" ]]; then
                    temp=$(sensors 2>/dev/null | grep -i "cpu temp\|coretemp" | head -1 | grep -oE '[0-9]+\.?[0-9]*' | head -1)
                fi
                ;;
            *)
                temp=$(sensors 2>/dev/null | grep -E "Core|Package|CPU|cpu" | head -1 | grep -oE '[0-9]+\.?[0-9]*' | head -1)
                ;;
        esac
    fi

    if [[ -z "$temp" ]]; then
        for hwmon in /sys/class/hwmon/hwmon*/; do
            if [[ -f "${hwmon}name" ]]; then
                name=$(cat "${hwmon}name" 2>/dev/null)

                case "$vendor" in
                    "AuthenticAMD")
                        if [[ "$name" == "k10temp" ]] || [[ "$name" =~ zenpower ]]; then
                            for temp_file in "${hwmon}"temp*_input; do
                                if [[ -f "$temp_file" ]]; then
                                    raw_temp=$(cat "$temp_file" 2>/dev/null)
                                    if [[ "$raw_temp" =~ ^[0-9]+$ ]] && [[ $raw_temp -gt 20000 ]] && [[ $raw_temp -lt 120000 ]]; then
                                        temp=$(awk "BEGIN {printf \"%.1f\", $raw_temp / 1000}")
                                        break 2
                                    fi
                                fi
                            done
                        fi
                        ;;
                    "GenuineIntel")
                        if [[ "$name" == "coretemp" ]] || [[ "$name" =~ intel ]]; then
                            for temp_file in "${hwmon}"temp*_input; do
                                if [[ -f "$temp_file" ]]; then
                                    raw_temp=$(cat "$temp_file" 2>/dev/null)
                                    if [[ "$raw_temp" =~ ^[0-9]+$ ]] && [[ $raw_temp -gt 20000 ]] && [[ $raw_temp -lt 120000 ]]; then
                                        temp=$(awk "BEGIN {printf \"%.1f\", $raw_temp / 1000}")
                                        break 2
                                    fi
                                fi
                            done
                        fi
                        ;;
                esac
            fi
        done
    fi

    if [[ -z "$temp" ]]; then
        for hwmon in /sys/class/hwmon/hwmon*/; do
            for temp_file in "${hwmon}"temp*_input; do
                if [[ -f "$temp_file" ]]; then
                    raw_temp=$(cat "$temp_file" 2>/dev/null)
                    if [[ "$raw_temp" =~ ^[0-9]+$ ]] && [[ $raw_temp -gt 20000 ]] && [[ $raw_temp -lt 120000 ]]; then
                        temp=$(awk "BEGIN {printf \"%.1f\", $raw_temp / 1000}")
                        break 2
                    fi
                fi
            done
        done
    fi

    if [[ ! "$temp" =~ ^[0-9]+\.?[0-9]*$ ]] || [[ -z "$temp" ]]; then
        temp="0"
    fi

    echo "$temp"
}

main() {
    local ccd_config output total_freq cpu_temp
    ccd_config=$(get_ccd_config)

    while IFS=':' read -r ccd_id cores; do
        if [[ -n "$cores" ]]; then
            local load
            load=$(get_ccd_load "$cores")
            [[ ! "$load" =~ ^[0-9]+$ ]] && load=0
            output+="GRP$ccd_id:$load% "
        fi
    done < <(echo "$ccd_config" | tail -n +2)

    total_freq=$(get_total_freq)
    cpu_temp=$(get_cpu_temp)

    [[ ! "$total_freq" =~ ^[0-9]+\.?[0-9]*$ ]] && total_freq="0.00"
    [[ ! "$cpu_temp" =~ ^[0-9]+\.?[0-9]*$ ]] && cpu_temp="0"

    output+="${total_freq}GHz ${cpu_temp}°C"
    echo "$output"
}

case "${1:-}" in
    --freq)
        freq=$(get_total_freq)
        [[ ! "$freq" =~ ^[0-9]+\.?[0-9]*$ ]] && freq="0.00"
        echo "${freq}GHz"
        ;;
    --temp)
        temp=$(get_cpu_temp)
        [[ ! "$temp" =~ ^[0-9]+\.?[0-9]*$ ]] && temp="0"
        echo "${temp}°C"
        ;;
    *)
        main
        ;;
esac
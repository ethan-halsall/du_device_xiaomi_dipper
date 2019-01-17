#!/system/bin/sh

#Script by rodries @xda, oipr @xda and milouk @xda

setSphinxConfig() {

sleep 20

# Set the default IRQ affinity to the silver cluster. When a
# CPU is isolated/hotplugged, the IRQ affinity is adjusted
# to one of the CPU from the default IRQ affinity mask.
echo f > /proc/irq/default_smp_affinity

# Core control parameters
echo 2 > /sys/devices/system/cpu/cpu4/core_ctl/min_cpus
echo 60 > /sys/devices/system/cpu/cpu4/core_ctl/busy_up_thres
echo 30 > /sys/devices/system/cpu/cpu4/core_ctl/busy_down_thres
echo 100 > /sys/devices/system/cpu/cpu4/core_ctl/offline_delay_ms
echo 1 > /sys/devices/system/cpu/cpu4/core_ctl/is_big_cluster
echo 4 > /sys/devices/system/cpu/cpu4/core_ctl/task_thres

# Setting b.L scheduler parameters
echo 95 > /proc/sys/kernel/sched_upmigrate
echo 85 > /proc/sys/kernel/sched_downmigrate
echo 100 > /proc/sys/kernel/sched_group_upmigrate
echo 95 > /proc/sys/kernel/sched_group_downmigrate
echo 0 > /proc/sys/kernel/sched_select_prev_cpu_us
echo 400000 > /proc/sys/kernel/sched_freq_inc_notify
echo 400000 > /proc/sys/kernel/sched_freq_dec_notify
echo 5 > /proc/sys/kernel/sched_spill_nr_run
echo 1 > /proc/sys/kernel/sched_restrict_cluster_spill
echo 1 > /proc/sys/kernel/sched_walt_rotate_big_tasks

echo 0 > /proc/sys/kernel/sched_child_runs_first
echo 0 > /proc/sys/kernel/sched_initial_task_util

#Configure Thermal Profile
echo 10 > /sys/class/thermal/thermal_message/sconfig


# configure boosts
echo 15 > /sys/module/cpu_boost/parameters/dynamic_stune_boost;
echo 250 > /sys/module/cpu_boost/parameters/input_boost_ms
echo 500 > /sys/module/cpu_boost/parameters/powerkey_input_boost_ms
echo "0:0" > /sys/module/cpu_boost/parameters/input_boost_freq

# Disable touchboost
echo 0 > /sys/module/msm_performance/parameters/touchboost

# Tweak IO performance after boot complete
echo "bfq" > /sys/block/sda/queue/scheduler
echo 128 > /sys/block/sda/queue/read_ahead_kb
echo 128 > /sys/block/sda/queue/nr_requests
echo 1 > /sys/block/sda/queue/iostats
echo 128 > /sys/block/sdf/queue/read_ahead_kb
echo 128 > /sys/block/sdf/queue/nr_requests
echo 1 > /sys/block/sdf/queue/iostats

# Enable scheduler core_ctl
echo 1 > /sys/devices/system/cpu/cpu0/core_ctl/enable
echo 1 > /sys/devices/system/cpu/cpu4/core_ctl/enable

# Enable Power Efficient Workqueques
echo 1 > /sys/module/workqueue/parameters/power_efficient

#Diaable Fsync
echo Y > /sys/module/sync/parameters/fsync_enabled

# set default schedTune value for foreground/top-app (only affects EAS)
echo 1 > /dev/stune/foreground/schedtune.prefer_idle
echo 1 > /dev/stune/top-app/schedtune.prefer_idle
echo 5 > /dev/stune/foreground/schedtune.sched_boost
echo 0 > /dev/stune/background/schedtune.sched_boost
echo 20 > /dev/stune/top-app/schedtune.sched_boost
echo 0 > /dev/stune/top-app/schedtune.boost
echo 0 > /dev/stune/background/schedtune.prefer_idle
echo 0 > /dev/stune/foreground/schedtune.boost
echo 0 > /dev/stune/foreground/schedtune.prefer_idle
echo 0 > /dev/stune/schedtune.prefer_idle

# Increase how much CPU bandwidth (CPU time) realtime scheduling processes are given
echo "980000" > /proc/sys/kernel/sched_rt_runtime_us

# Network tweaks for slightly reduced battery consumption when being "actively" connected to a network connection;
echo "westwood" > /proc/sys/net/ipv4/tcp_congestion_control

#set defult governor
# configure governor settings for little cluster
echo "schedutil" > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
echo 1209600 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/hispeed_freq
echo 1 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/pl
echo 500 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/up_rate_limit_us
echo 20000 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/down_rate_limit_us 
echo 1 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/iowait_boost_enable
	

# configure governor settings for big cluster
echo "schedutil" > /sys/devices/system/cpu/cpufreq/policy4/scaling_governor
echo 1574400 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/hispeed_freq
echo 1 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/pl
echo 500 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/up_rate_limit_us
echo 20000 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/down_rate_limit_us 
echo 1 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/iowait_boost_enable

#force min_freq
echo 300000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 300000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
echo 300000 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
echo 300000 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq


#force min_freq 
echo 825600 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
echo 825600 > /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq
echo 825600 > /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq
echo 825600 > /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq

#Configire LMK
echo "14392,28784,43176,57568,71960,86352" > /sys/module/lowmemorykiller/parameters/minfree
echo 0 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk

# Enable oom_reaper
echo 1 > /sys/module/lowmemorykiller/parameters/oom_reaper


# Enable bus-dcvs
for cpubw in /sys/class/devfreq/*qcom,cpubw*
do
    echo "bw_hwmon" > $cpubw/governor
    echo 50 > $cpubw/polling_interval
    echo "2288 4577 6500 8132 9155 10681" > $cpubw/bw_hwmon/mbps_zones
    echo 4 > $cpubw/bw_hwmon/sample_ms
    echo 50 > $cpubw/bw_hwmon/io_percent
    echo 20 > $cpubw/bw_hwmon/hist_memory
    echo 10 > $cpubw/bw_hwmon/hyst_length
    echo 0 > $cpubw/bw_hwmon/guard_band_mbps
    echo 250 > $cpubw/bw_hwmon/up_scale
    echo 1600 > $cpubw/bw_hwmon/idle_mbps
done

for llccbw in /sys/class/devfreq/*qcom,llccbw*
do
    echo "bw_hwmon" > $llccbw/governor
    echo 50 > $llccbw/polling_interval
    echo "1720 2929 3879 5931 6881" > $llccbw/bw_hwmon/mbps_zones
    echo 4 > $llccbw/bw_hwmon/sample_ms
    echo 80 > $llccbw/bw_hwmon/io_percent
    echo 20 > $llccbw/bw_hwmon/hist_memory
    echo 10 > $llccbw/bw_hwmon/hyst_length
    echo 0 > $llccbw/bw_hwmon/guard_band_mbps
    echo 250 > $llccbw/bw_hwmon/up_scale
    echo 1600 > $llccbw/bw_hwmon/idle_mbps
done

#Enable mem_latency governor for DDR scaling
for memlat in /sys/class/devfreq/*qcom,memlat-cpu*
do
    echo "mem_latency" > $memlat/governor
    echo 10 > $memlat/polling_interval
    echo 400 > $memlat/mem_latency/ratio_ceil
done

#Enable mem_latency governor for L3 scaling
for memlat in /sys/class/devfreq/*qcom,l3-cpu*
do
    echo "mem_latency" > $memlat/governor
    echo 10 > $memlat/polling_interval
    echo 400 > $memlat/mem_latency/ratio_ceil
done

#Enable userspace governor for L3 cdsp nodes
for l3cdsp in /sys/class/devfreq/*qcom,l3-cdsp*
do
    echo "userspace" > $l3cdsp/governor
    chown -h system $l3cdsp/userspace/set_freq
done

	#Gold L3 ratio ceil
echo 4000 > /sys/class/devfreq/soc:qcom,l3-cpu4/mem_latency/ratio_ceil

echo "compute" > /sys/class/devfreq/soc:qcom,mincpubw/governor
echo 10 > /sys/class/devfreq/soc:qcom,mincpubw/polling_interval

# Turn on sleep modes.
echo N > /sys/module/lpm_levels/parameters/sleep_disabled

# Configure Zram parameters
echo 100 > /proc/sys/vm/swappiness
echo 120 > /proc/sys/vm/watermark_scale_factor

#Enable suspend to idle mode to reduce latency during suspend/resume
write /sys/power/mem_sleep "s2idle"

# Disable CPU Retention
echo N > /sys/module/lpm_levels/L3/cpu0/rail-pc/idle_enabled
echo N > /sys/module/lpm_levels/L3/cpu1/rail-pc/idle_enabled
echo N > /sys/module/lpm_levels/L3/cpu2/rail-pc/idle_enabled
echo N > /sys/module/lpm_levels/L3/cpu3/rail-pc/idle_enabled
echo N > /sys/module/lpm_levels/L3/cpu4/rail-pc/idle_enabled
echo N > /sys/module/lpm_levels/L3/cpu5/rail-pc/idle_enabled
echo N > /sys/module/lpm_levels/L3/cpu6/rail-pc/idle_enabled
echo N > /sys/module/lpm_levels/L3/cpu7/rail-pc/idle_enabled

echo N > /sys/module/lpm_levels/L3/cpu0/pc/idle_enabled
echo N > /sys/module/lpm_levels/L3/cpu1/pc/idle_enabled
echo N > /sys/module/lpm_levels/L3/cpu2/pc/idle_enabled
echo N > /sys/module/lpm_levels/L3/cpu3/pc/idle_enabled
echo N > /sys/module/lpm_levels/L3/cpu4/pc/idle_enabled
echo N > /sys/module/lpm_levels/L3/cpu5/pc/idle_enabled
echo N > /sys/module/lpm_levels/L3/cpu6/pc/idle_enabled
echo N > /sys/module/lpm_levels/L3/cpu7/pc/idle_enabled

echo N > /sys/module/lpm_levels/L3/l3-wfi/idle_enabled
echo N > /sys/module/lpm_levels/L3/llcc-off/idle_enabled

# Toggle Sched Features
echo "NO_FBT_STRICT_ORDER" > /sys/kernel/debug/sched_features


sleep 30
#force min_freq again  
echo 300000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 300000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
echo 300000 > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
echo 300000 > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq

#force min_freq 
echo 825600 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
echo 825600 > /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq
echo 825600 > /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq
echo 825600 > /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq

}

setSphinxConfig &

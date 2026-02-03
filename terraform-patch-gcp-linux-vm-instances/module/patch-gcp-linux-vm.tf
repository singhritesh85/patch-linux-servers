data "google_compute_zones" "all_available_zones" {
  project = var.project_name
}

resource "google_os_config_patch_deployment" "gcp_linux_vm_patch" {
  patch_deployment_id = "${var.prefix}-weekly-linux-patch"
  
  instance_filter {
    all = false
    zones = data.google_compute_zones.all_available_zones.names
    group_labels {
      labels = {
        patch = "scheduled"
      }
    }
  }

  patch_config {
    reboot_config = "DEFAULT"   ### determine if a reboot is necessary based on operating system-specific signals
    apt {
      type = "DIST"    ### UPGRADE. For patch all packages including kernel apt-get dist-upgrade is required.
    }
    yum {
       ### Default behavior is to patch all packages.
#      security = true
#      minimal = true
      excludes = [""]
    }
  }

  recurring_schedule {
    ### Scheduled on Every Saturday at 12:00 AM UTC.
    time_zone {
      id = "UTC"
    }
    weekly {
      day_of_week = "SATURDAY"
    }
    time_of_day {
      hours = 0
      minutes = 0
      seconds = 0
      nanos = 0
    }
  }
 
  duration = "10800s" ### Maintenace Window for 3 hours in seconds

  rollout {
    mode = "ZONE_BY_ZONE"
    disruption_budget {
      percentage = 20
    }
  }
}

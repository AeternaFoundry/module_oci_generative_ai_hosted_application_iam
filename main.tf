resource "oci_generative_ai_hosted_application_iam" "generative_ai_hosted_application_iams" {
  for_each = var.generative_ai_hosted_application_iams

  compartment_id = each.value.compartment_id
  display_name   = each.value.display_name
  defined_tags   = each.value.defined_tags
  description    = each.value.description
  freeform_tags  = each.value.freeform_tags

  dynamic "environment_variables" {
    for_each = each.value.environment_variables != null ? each.value.environment_variables : []
    content {
      name  = environment_variables.value.name
      type  = environment_variables.value.type
      value = environment_variables.value.value
    }
  }

  dynamic "networking_config" {
    for_each = each.value.networking_config != null ? [each.value.networking_config] : []
    content {
      inbound_networking_config {
        endpoint_mode       = networking_config.value.inbound_networking_config.endpoint_mode
        private_endpoint_id = networking_config.value.inbound_networking_config.private_endpoint_id
      }
      outbound_networking_config {
        custom_subnet_id = networking_config.value.outbound_networking_config.custom_subnet_id
        network_mode     = networking_config.value.outbound_networking_config.network_mode
        nsg_ids          = networking_config.value.outbound_networking_config.nsg_ids
      }
    }
  }

  dynamic "scaling_config" {
    for_each = each.value.scaling_config != null ? [each.value.scaling_config] : []
    content {
      max_replica                  = scaling_config.value.max_replica
      min_replica                  = scaling_config.value.min_replica
      scaling_type                 = scaling_config.value.scaling_type
      target_concurrency_threshold = scaling_config.value.target_concurrency_threshold
      target_cpu_threshold         = scaling_config.value.target_cpu_threshold
      target_memory_threshold      = scaling_config.value.target_memory_threshold
      target_rps_threshold         = scaling_config.value.target_rps_threshold
    }
  }

  dynamic "storage_configs" {
    for_each = each.value.storage_configs != null ? each.value.storage_configs : []
    content {
      environment_variable_key = storage_configs.value.environment_variable_key
      storage_id               = storage_configs.value.storage_id
    }
  }

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      update = timeouts.value.update
    }
  }
}


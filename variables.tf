variable "generative_ai_hosted_application_iams" {
  description = <<EOT
Map of generative_ai_hosted_application_iams, attributes below
Required:
    - compartment_id
    - display_name
Optional:
    - defined_tags
    - description
    - freeform_tags
    - environment_variables (block):
        - name (required)
        - type (required)
        - value (required)
    - networking_config (block):
        - inbound_networking_config (required, block):
            - endpoint_mode (required)
            - private_endpoint_id (optional)
        - outbound_networking_config (required, block):
            - custom_subnet_id (optional)
            - network_mode (required)
            - nsg_ids (optional)
    - scaling_config (block):
        - max_replica (optional)
        - min_replica (optional)
        - scaling_type (required)
        - target_concurrency_threshold (optional)
        - target_cpu_threshold (optional)
        - target_memory_threshold (optional)
        - target_rps_threshold (optional)
    - storage_configs (block):
        - environment_variable_key (required)
        - storage_id (required)
    - timeouts (block):
        - create (optional)
        - delete (optional)
        - update (optional)
EOT

  type = map(object({
    compartment_id = string
    display_name   = string
    defined_tags   = optional(map(string))
    description    = optional(string)
    freeform_tags  = optional(map(string))
    environment_variables = optional(list(object({
      name  = string
      type  = string
      value = string
    })))
    networking_config = optional(object({
      inbound_networking_config = object({
        endpoint_mode       = string
        private_endpoint_id = optional(string)
      })
      outbound_networking_config = object({
        custom_subnet_id = optional(string)
        network_mode     = string
        nsg_ids          = optional(set(string))
      })
    }))
    scaling_config = optional(object({
      max_replica                  = optional(number)
      min_replica                  = optional(number)
      scaling_type                 = string
      target_concurrency_threshold = optional(number)
      target_cpu_threshold         = optional(number)
      target_memory_threshold      = optional(number)
      target_rps_threshold         = optional(number)
    }))
    storage_configs = optional(list(object({
      environment_variable_key = string
      storage_id               = string
    })))
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      update = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.generative_ai_hosted_application_iams : (
        v.environment_variables == null || alltrue([for item in v.environment_variables : (can(jsondecode(item.value)))])
      )
    ])
    error_message = "must be valid JSON"
  }
}


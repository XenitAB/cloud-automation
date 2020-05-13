package terraform.analysis

input_create_aws_subnet = {
  "resource_changes": [
    {
      "change": {
        "actions": [
          "create"
        ]
      },
      "type": "aws_subnet"
    }
  ]
}

input_delete_aws_subnet = {
  "resource_changes": [
    {
      "change": {
        "actions": [
          "delete"
        ]
      },
      "type": "aws_subnet"
    }
  ]
}

input_update_aws_subnet = {
  "resource_changes": [
    {
      "change": {
        "actions": [
          "update"
        ]
      },
      "type": "aws_subnet"
    }
  ]
}

test_create_aws_subnet {
    authz with input as input_create_aws_subnet
}

test_delete_aws_subnet {
    not authz with input as input_delete_aws_subnet
}

test_update_aws_subnet {
    authz with input as input_update_aws_subnet
}
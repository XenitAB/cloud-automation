package terraform.analysis

input_create_aws_iam_role = {
  "resource_changes": [
    {
      "change": {
        "actions": [
          "create"
        ]
      },
      "type": "aws_iam_role"
    }
  ]
}

input_delete_aws_iam_role = {
  "resource_changes": [
    {
      "change": {
        "actions": [
          "delete"
        ]
      },
      "type": "aws_iam_role"
    }
  ]
}

input_update_aws_iam_role = {
  "resource_changes": [
    {
      "change": {
        "actions": [
          "update"
        ]
      },
      "type": "aws_iam_role"
    }
  ]
}

test_create_aws_iam_role {
    authz with input as input_create_aws_iam_role
}

test_delete_aws_iam_role {
    authz with input as input_delete_aws_iam_role
}

test_update_aws_iam_role {
    authz with input as input_update_aws_iam_role
}
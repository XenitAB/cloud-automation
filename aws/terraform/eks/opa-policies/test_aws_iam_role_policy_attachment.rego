package terraform.analysis

input_create_aws_iam_role_policy_attachment = {
  "resource_changes": [
    {
      "change": {
        "actions": [
          "create"
        ]
      },
      "type": "aws_iam_role_policy_attachment"
    }
  ]
}

input_delete_aws_iam_role_policy_attachment = {
  "resource_changes": [
    {
      "change": {
        "actions": [
          "delete"
        ]
      },
      "type": "aws_iam_role_policy_attachment"
    }
  ]
}

input_update_aws_iam_role_policy_attachment = {
  "resource_changes": [
    {
      "change": {
        "actions": [
          "update"
        ]
      },
      "type": "aws_iam_role_policy_attachment"
    }
  ]
}

test_create_aws_iam_role_policy_attachment {
    authz with input as input_create_aws_iam_role_policy_attachment
}

test_delete_aws_iam_role_policy_attachment {
    authz with input as input_delete_aws_iam_role_policy_attachment
}

test_update_aws_iam_role_policy_attachment {
    authz with input as input_update_aws_iam_role_policy_attachment
}
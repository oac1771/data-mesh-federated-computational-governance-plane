package dataapi.authz

# If the conditions between the curly braces are true then Fybrik will get an object containing information about
# "RedactAction".
rule[{"action": {"name":"RedactAction", "columns": column_names}, "policy": description}] {
  description := "Redact columns tagged as PII.Sensitive in datasets tagged with Purpose.finance = true"
  # this condition is true if it is a read operation
  input.action.actionType == "read"
  # this condition is true if the asset has "Purpose.finance" tag
  input.resource.metadata.tags["Purpose.finance"]
  # this statement assigns to column_names variable all the columns that contain "PII.Sensitive" tag
  column_names := [input.resource.metadata.columns[i].name | input.resource.metadata.columns[i].tags["PII.Sensitive"]]
  # this condition is true if column_names is not empty
  # we need this check to apply the RedactAction action only in cases where sensitive data exists.
  count(column_names) > 0
}

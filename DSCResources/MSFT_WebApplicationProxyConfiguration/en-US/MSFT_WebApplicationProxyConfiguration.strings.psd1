# culture="en-US"
ConvertFrom-StringData @'
    GettingResourceMessage                   = Getting '{0}'. (WAPC0001)
    SettingResourceMessage                   = Setting '{0}' property '{1}' to '{2}'. (WAPC0002)
    ResourceInDesiredStateMessage            = '{0}' is in the desired state. (WAPC0003)
    ResourcePropertyNotInDesiredStateMessage = '{0}' Property '{1}' is not in the desired state, expected '{2}', actual '{3}'. (WAPC0004)
    GettingResourceError                     = Error getting '{0}'. (WAPC0005)
    SettingResourceError                     = Error setting '{0}'. (WAPC0006)
'@

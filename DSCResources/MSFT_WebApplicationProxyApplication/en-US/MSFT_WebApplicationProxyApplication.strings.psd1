# culture="en-US"
ConvertFrom-StringData @'
    GettingResourceMessage                   = Getting '{0}'. (WAPA0001)
    SettingResourceMessage                   = Setting '{0}' property '{1}' to '{2}'. (WAPA0002)
    AddingResourceMessage                    = Adding '{0}'. (WAPA0003)
    RecreatingResourceMessage                = AdfsRelyingPartyName changed. {0} needs recreating. (WAP0004)
    RemovingResourceMessage                  = Removing '{0}'. (WAPA0005)
    ResourceInDesiredStateMessage            = '{0}' in the desired state. (WAPA0006)
    ResourcePropertyNotInDesiredStateMessage = '{0}' Property '{1}' is not in the desired state. Expected: '{2}', Actual: '{3}'. (WAPA0007)
    ResourceExistsButShouldNotMessage        = '{0}' exists but should not. (WAPA0008)
    ResourceDoesNotExistButShouldMessage     = '{0}' does not exist but should. (WAPA0009)
    ResourceDoesNotExistAndShouldNotMessage  = '{0}' does not exist and should not. (WAPA0010)
    RemovingResourceError                    = Error removing '{0}'. (WAPA0011)
'@

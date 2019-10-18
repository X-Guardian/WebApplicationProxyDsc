# Localized resources for helper module AdfsDsc.Common.

ConvertFrom-StringData @'
    EvaluatePropertyState                  = Evaluating the state of the property '{0}'. (ADFSCOMMON0003)
    PropertyInDesiredState                 = The parameter '{0}' is in desired state. (ADFSCOMMON0004)
    PropertyNotInDesiredState              = The parameter '{0}' is not in desired state. (ADFSCOMMON0005)
    ArrayDoesNotMatch                      = One or more values in an array does not match the desired state. Details of the changes are below. (ADFSCOMMON0006)
    ArrayValueThatDoesNotMatch             = {0} - {1} (ADFSCOMMON0007)
    PropertyValueOfTypeDoesNotMatch        = {0} value does not match. Current value is '{1}', but expected the value '{2}'. (ADFSCOMMON0008)
    UnableToCompareType                    = Unable to compare the type {0} as it is not handled by the Test-DscPropertyState cmdlet. (ADFSCOMMON0009)
    ModuleNotFoundError                    = Please ensure that the PowerShell module for role '{0}' is installed. (ADFSCOMMON0010)
    ConfigurationStatusNotFoundError       = The ADFS configuration status registry entry does not exist.
    UnknownConfigurationStatusError        = The ADFS configuration status registry entry contains an unknown value {0}.
'@

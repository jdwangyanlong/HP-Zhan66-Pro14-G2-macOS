// disable RP01,ReadCARD
DefinitionBlock ("", "SSDT", 2, "ACDT", "noRP01", 0)
{
    External (_SB.PCI0.RP01, DeviceObj)

    Scope (_SB.PCI0.RP01)
    {
        Method (_STA, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                Return (0)
            }
            Else
            {
                Return (0x0F)
            }
        }
    }
}
//EOF
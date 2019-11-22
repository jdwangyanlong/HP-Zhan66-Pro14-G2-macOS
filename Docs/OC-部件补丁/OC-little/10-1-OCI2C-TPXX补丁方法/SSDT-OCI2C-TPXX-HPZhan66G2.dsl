//ACPI Patch
//Comment: Return Zero in _STA of TPD0
//Find:    5f53544100a40a0f1433
//Replace: 5f53544100a40a001433

// TPxx is my new's device
DefinitionBlock("", "SSDT", 2, "ACDT", "I2C-TPXX", 0)
{

    External (_SB_.GNUM, MethodObj)    // 1 Arguments
    External (_SB_.PCI0.HIDD, MethodObj)    // 5 Arguments
    External (_SB_.PCI0.HIDG, IntObj)
    External (_SB_.PCI0.I2C1, DeviceObj)
    External (_SB_.PCI0.TP7D, MethodObj)    // 6 Arguments
    External (_SB_.PCI0.TP7G, IntObj)
    External (_SB_.SHPO, MethodObj)    // 2 Arguments
    External (GPDI, FieldUnitObj)
    External (HPID, FieldUnitObj)
    External (SDM1, FieldUnitObj)
    
    //path:_SB.PCI0.I2C1.TPD0
    Scope (_SB.PCI0.I2C1)
    {
        Device (TPXX)
        {
            Name (HID2, Zero)
            Name (SBFB, ResourceTemplate ()
            {
                I2cSerialBusV2 (0x002C, ControllerInitiated, 0x00061A80,
                    AddressingMode7Bit, "\\_SB.PCI0.I2C1",
                    0x00, ResourceConsumer, _Y42, Exclusive,
                    )
            })
            Name (SBFG, ResourceTemplate ()
            {
                GpioInt (Level, ActiveLow, ExclusiveAndWake, PullDefault, 0x0000,
                    "\\_SB.PCI0.GPI0", 0x00, ResourceConsumer, ,
                    )
                    {   // Pin list
                        0x0063
                    }
            })
            CreateWordField (SBFB, \_SB.PCI0.I2C1.TPXX._Y42._ADR, BADR)  // _ADR: Address
            CreateDWordField (SBFB, \_SB.PCI0.I2C1.TPXX._Y42._SPE, SPED)  // _SPE: Speed
            CreateWordField (SBFG, 0x17, INT1)
            Method (_INI, 0, NotSerialized)  // _INI: Initialize
            {

                INT1 = GNUM (GPDI)
                If ((SDM1 == Zero))
                {
                    SHPO (GPDI, One)
                }

                HID2 = 0x20
                BADR = 0x2C
                SPED = 0x00061A80
            }

            Method (_HID, 0, NotSerialized)  // _HID: Hardware ID
            {
                If (Zero)
                {
                    If ((HPID == 0x103C00B8))
                    {
                        Return ("SYNA3083")
                    }
                    ElseIf ((HPID == 0x103C00BB))
                    {
                        Return ("SYNA3082")
                    }
                    ElseIf ((HPID == 0x103C00BA))
                    {
                        Return ("SYNA3081")
                    }
                    Else
                    {
                        Return ("SYNA30FF")
                    }
                }
                ElseIf ((HPID == 0x103C00B8))
                {
                    Return ("SYNA309E")
                }
                ElseIf ((HPID == 0x103C00BB))
                {
                    Return ("SYNA309A")
                }
                ElseIf ((HPID == 0x103C00BA))
                {
                    Return ("SYNA309B")
                }
                Else
                {
                    Return ("SYNA309A")
                }
            }

            Name (_CID, "PNP0C50" /* HID Protocol Device (I2C bus) */)  // _CID: Compatible ID
            Name (_S0W, 0x03)  // _S0W: S0 Device Wake State
            Method (_DSM, 4, Serialized)  // _DSM: Device-Specific Method
            {
                If ((Arg0 == HIDG))
                {
                    Return (HIDD (Arg0, Arg1, Arg2, Arg3, HID2))
                }

                If ((Arg0 == TP7G))
                {
                    Return (TP7D (Arg0, Arg1, Arg2, Arg3, SBFB, SBFG))
                }

                Return (Buffer (One)
                {
                     0x00                                             // .
                })
            }

            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }

            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Return (ConcatenateResTemplate (SBFB, SBFG))
            }
        }
    }
}
//EOF
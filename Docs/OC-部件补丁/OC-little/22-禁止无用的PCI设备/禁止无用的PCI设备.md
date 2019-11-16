## 禁止无用的PCI设备

#### 描述

- 当MAC系统无法驱动某个设备时，可以使用补丁禁用它。比如，PCI总线的SD卡通常不能被驱动，即使驱动了也几乎不能正常工作。这种情况下，我们可以通过第三方的SSDT文件禁止它。

#### 示例

- dell Latitude5480 的SD卡属于PCI设备，设备路径：`_SB.PCI0.RP01.PXSX` ，方法：禁用设备所属的的 **父** 。

- 补丁文件：***SSDT-RP01-disbale*** 

- ```
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
  ```

#### 注意

- 如果被禁用设备所属的 **父** 关联了其他设备，请 **谨慎使用** 本方法。
- 如果被禁用设备所属的 **父** 已经存在了 `_STA` ，请使用《预置变量法》禁用该设备。



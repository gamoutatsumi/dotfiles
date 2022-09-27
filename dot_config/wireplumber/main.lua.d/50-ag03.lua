rule = {
  {
    matches = {
      {
        {"node.name", "equals", "alsa_output.usb-Yamaha_Corporation_Yamaha_AG03MK2-00.iec958-stereo"},
      },
    },
    apply_properties = {
      ["audio.format"] = "S32_LE",
      ["audio.rate"] = 96000,
      ["api.alsa.period-size"] = 128,
    }
  }
}

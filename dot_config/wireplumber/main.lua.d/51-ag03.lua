rule = {
  matches = {
    {
      { "node.name", "matches", "alsa_output.usb-Yamaha_Corporation_Yamaha_AG03MK2-00.iec958-stereo" },
    },
  },
  apply_properties = {
    ["audio.allowed-rates"] = "192000,176400,96000,88200,48000,44100",
    ["audio.format"] = "S32_LE",
  },
}
table.insert (alsa_monitor.rules, rule)

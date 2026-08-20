export const NotificationPlugin = async ({ $ }) => {
  const isWSL = !!(process.env.WSL_DISTRO_NAME || process.env.WSL_INTEROP)
  const host = process.env.WSL_HOST_IP || ''

  const title = 'opencode'
  const message = '任务完成 ✅'

  const notifyWindows = async () => {
    const ps = [
      'Add-Type -AssemblyName System.Windows.Forms',
      'Add-Type -AssemblyName System.Drawing',
      '$tip = New-Object System.Windows.Forms.NotifyIcon',
      '$tip.Icon = [System.Drawing.SystemIcons]::Information',
      '$tip.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info',
      `$tip.BalloonTipTitle = '${title}'`,
      `$tip.BalloonTipText = '${message}'`,
      '$tip.Visible = $true',
      '$tip.ShowBalloonTip(5000)',
      'Start-Sleep -Seconds 6',
      '$tip.Dispose()'
    ].join('; ')
    await $`powershell.exe -NoProfile -WindowStyle Hidden -Command ${ps}`.quiet()
  }

  const notifyLinux = async () => {
    if (process.env.DISPLAY || process.env.WAYLAND_DISPLAY) {
      await $`notify-send ${title} ${message}`.quiet()
    }
  }

  return {
    event: async ({ event }) => {
      if (event.type === 'session.idle') {
        try {
          if (isWSL) {
            await notifyWindows()
          } else {
            await notifyLinux()
          }
        } catch (err) {
          console.error('[notification] failed:', err)
        }
      }
    }
  }
}

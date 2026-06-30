package cpp;

#if windows
@:buildXml('
<target id="haxe">
	<lib name="wininet.lib" if="windows" />
	<lib name="dwmapi.lib" if="windows" />
</target>
')
@:cppFileCode('
#include <dwmapi.h>
#include <windows.h>
#include <winuser.h>
#pragma comment(lib, "Shell32.lib")
extern "C" HRESULT WINAPI SetCurrentProcessExplicitAppUserModelID(PCWSTR AppID);
')
#end
class Windows
{
	/**
	 * DPI Scaling fix
	 *
	 * only supported on windows
	 *
	 * Thanks to YoshiCrafter29 & the CNE Crew
	 */
	public static function setDpiAware()
	{
		final window = lime.app.Application.current.window;

		if (window == null) return;

		final dpiScale = (lime.system.System.getDisplay(0)?.dpi / 96) ?? 1.0;

		@:privateAccess
		{
			window.width = Std.int(Main.startMeta.width * dpiScale);
			window.height = Std.int(Main.startMeta.height * dpiScale);
		}

		window.x = Std.int((window.display.bounds.width - window.width) / 2);
		window.y = Std.int((window.display.bounds.height - window.height) / 2);
	}

	/**
	 * Sets the window to either `Dark` or `Light` mode
	 *
	 * only supported on windows
	 * @param isDark
	 */
	public static function setDarkMode(isDark:Bool = true)
	{
		#if (windows && cpp)
		final dark:Int = isDark ? 1 : 0;
		untyped __cpp__("
                int darkMode = dark;
                HWND window = GetActiveWindow();
                if (S_OK != DwmSetWindowAttribute(window, 19, &darkMode, sizeof(darkMode))) {
                    DwmSetWindowAttribute(window, 20, &darkMode, sizeof(darkMode));
                }
                UpdateWindow(window);
            ");

		FlxG.stage.window.borderless = true;
		FlxG.stage.window.borderless = false;
		#end
	}
}

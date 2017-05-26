package {
    import com.adjust.sdk.Adjust;
    import com.adjust.sdktesting.AdjustTesting;

    import flash.display.SimpleButton;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.system.Capabilities;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;

    public class Main extends Sprite {
        private static var IsEnabledTextField:TextField;
        private static var commandExecutor:CommandExecutor = new CommandExecutor();

        public function Main() {
            var baseUrl:String = 'https://192.168.8.246:8443';
            Adjust.setTestingMode(baseUrl);

            AdjustTesting.initTestSession(baseUrl, testingCommandCallbackDelegate);
        }

        private static function testingCommandCallbackDelegate(json:String):void {
            var data:Object = JSON.parse(json);
            var className:String = data.className;
            var functionName:String = data.functionName;
            var params:Object = data.params;

            trace('AS3>> className: ' + className);
            trace('AS3>> functionName: ' + functionName);
            trace('AS3>> params: ' + params);

            commandExecutor.executeCommand(functionName, params);
        }
    }
}

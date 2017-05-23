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

        public function Main() {
            //var baseUrl:String = 'https://10.0.2.2:8443';
            //var baseUrl:String = 'https://192.168.8.250:8443';
            var baseUrl:String = 'http://192.168.8.250:8080';
            Adjust.setTestingMode(baseUrl);

            AdjustTesting.initTestSession(baseUrl, testingCommandCallbackDelegate);
        }

        private static function testingCommandCallbackDelegate(json:String):void {
            var data:Object = JSON.parse(json);
            var className:String = data.className;
            var functionName:String = data.functionName;
            var params:String = data.params;

            trace('>>>>>>>>>> className: ' + className);
            trace('>>>>>>>>>> functionName: ' + functionName);
            trace('>>>>>>>>>> params: ' + params);
        }
    }
}

package;

import haxe.io.Encoding;
import sys.io.FileInput;
import sys.io.File;
import haxe.io.Bytes;
import haxe.io.BytesBuffer;

using StringTools;

@:forward
abstract IBytes(Bytes) {
	private static var _i:Int;

	var i(get, set):Int;

	inline public function new(b:Bytes, ii:Int = 0) {
		this = b;
		i = ii;
	}

	inline function get_i() {
		return _i;
	}

	inline function set_i(v:Int) {
		return _i = v;
	}

	public function hasNext() {
		return i < this.length - 1;
	}

	public function next() {
		i++;
		return this.get(i);
	}
}

class Main {
	public static function main() {
		var patcher = new Patcher();
		// var file = File.read('../chromedriver');

		// var s = Bytes.ofString("window.cdc_adoQpoasnfa76pfcZLmcfl_Symbol || window.Symbol;");
		// var s = Bytes.ofString("cdc_asdjflasutopfhvcZLmcfl");

		// var f = s.sub(7, Bytes.ofString("cdc_").length);

		// var c = 0x63;
		// var d = 0x64;
		// var _d = 0x5f;

		// trace(Bytes.ofString("cdc_"));

		// while (!file.eof()) {
		//     var b = readUntil(file, 0xa);
		//     file.readUntil();
		//     FileInput.
		//     var buf = new BytesBuffer();

		//     var i = 0;

		//     if(UnicodeString.validate(b,Encoding.UTF8)) {
		//         var s = b.toString();

		//         if(s.contains("cdc_")) {
		//             trace("YAYYY");
		//         }
		//     }
	}
}

// public static function readUntil(f:FileInput, end:Int) {
// 	var buf = new BytesBuffer();
// 	var last:Int;
// 	while ((last = f.readByte()) != end)
// 		buf.addByte(last);
// 	return buf.getBytes();
// }

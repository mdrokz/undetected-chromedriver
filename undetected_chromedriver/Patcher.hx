package;

import haxe.io.Encoding;
import haxe.io.BytesBuffer;
import sys.io.FileSeek;
import sys.io.FileInput;
import haxe.io.Bytes;
import EReg;
import haxe.zip.Reader;
import haxe.io.BytesInput;
import haxe.zip.Entry;
import sys.io.File;

using StringTools;
using Patcher.FileExtensions;

class FileExtensions {
	public static function readBytesUntil(f:FileInput, end:Int = 0xa) {
		var buf = new BytesBuffer();
		var last:Int;
		while ((last = f.readByte()) != end)
			buf.addByte(last);
		return buf.getBytes();
	}
}

class Patcher {
	var url_repo = "https://chromedriver.storage.googleapis.com/";
	var zip_name = "chromedriver_%s.zip";
	var exe_name = "chromedriver%s";
	final platform = Sys.systemName();

	public function unzip(archive:String, dir:String) {
		var zipfileBytes = File.getBytes(archive);
		var bytesInput = new BytesInput(zipfileBytes);
		var reader = new Reader(bytesInput);
		var entries:List<Entry> = reader.read();
		for (_entry in entries) {
			var data = Reader.unzip(_entry);
			if (_entry.fileName.substring(_entry.fileName.lastIndexOf('/') + 1) == '' && _entry.data.toString() == '') {
				sys.FileSystem.createDirectory(dir + _entry.fileName);
			} else {
				var f = File.write(dir + _entry.fileName, true);
				f.write(data);
				f.close();
			}
		}
	}

	public function fetch_release_version(c:(data:String) -> Void) {
		var r = new haxe.Http('https://chromedriver.storage.googleapis.com/LATEST_RELEASE');

		r.onData = c;

		r.request();
	}

	static public function gen_random_cdc() {
		var cdc = Random.string(26, 'abcdefghijklmnopqrstuvwxyz').split('');

		cdc[2] = cdc[0];
		cdc[3] = "_";
		for (i in (cdc.length - 6)...22) {
			cdc[i] = cdc[i].toUpperCase();
		}
		return Bytes.ofString(cdc.join(""));
	}

	public function fetch_package(c:() -> Void) {
		fetch_release_version((data:String) -> {
			trace(data);
			var request = new haxe.Http(url_repo + data + '/' + zip_name);

			var zip_file = File.write(zip_name, true);

			request.onBytes = (data:Bytes) -> {
				zip_file.writeBytes(data, 0, data.length);
				c();
			}

			request.request();
		});
	}

	public function patch_exe() {
		var read_file = File.read('chromedriver');
		// var f = new F('chromedriver');
		var write_file = File.update('chromedriver', true);

		while (!read_file.eof()) {
			var b = read_file.readBytesUntil();

			var replacement = gen_random_cdc();

			// trace(-b.length);
			if (UnicodeString.validate(b, Encoding.UTF8)) {
				var line = b.toString();

				trace(line);
				if (line.contains("cdc_")) {
					trace(b.length);
					write_file.seek(line.length, FileSeek.SeekCur);
					var r = new EReg('cdc_.{22}', 'i');

					var newline = r.replace(replacement.toString(), line);
					// trace(newline);
					write_file.writeString(newline);
				}
			}
		}
	}

	public function new() {
		if (platform == "Windows") {
			zip_name = zip_name.replace('%s', 'win32');
			exe_name += ".exe";
		} else if (platform == "Linux") {
			zip_name = zip_name.replace('%s', 'linux64');
			exe_name += "";
		} else if (platform == "Mac") {
			zip_name = zip_name.replace('%s', 'mac64');
			exe_name += "";
		}

		patch_exe();
		// fetch_package(() -> {
		// 	unzip('chromedriver_linux64.zip', '');
		// });
	}
}

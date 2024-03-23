import haxe.io.Bytes;
import PatchParsing;

@:structInit
@:publicFields
class PatchEdit {
	var formats:Array<PatchValueFormat>;

	final name_byte_start:Int = 9;
	final name_byte_count:Int = 16;

	function write_name(bytes:Bytes, chars:String):Void {
		var default_char_code = " ".charCodeAt(0);

		for (char_index in 0...name_byte_count) {
			var pos = char_index + name_byte_start;
			var char_code = char_index < chars.length ? chars.charCodeAt(char_index) : default_char_code;
			bytes.set(pos, char_code);
		}
	}

	function read_name(bytes:Bytes):String {
		return bytes.sub(name_byte_start, name_byte_count).toString();
	}

	function dump(bytes:Bytes){
		for (pos in 0...bytes.length) {
			trace(pos + ':'  + String.fromCharCode(bytes.get(pos)));
		}
	}
}

@:publicFields
@:structInit
class PatchValueFormat {
	var address:Int;
	var defined:Int;
	var minimum:Int;
	var maximum:Int;
	var name:String;
	var bit_shift:Int;

	public static function from_csv_format(data:PatchCsvFormat):PatchValueFormat {
		var bit_shift:Int = 0;

		return {
			address: Std.parseInt(data.address),
			defined: Std.parseInt(data.defined),
			minimum: Std.parseInt(data.minimum),
			maximum: Std.parseInt(data.maximum),
			name: data.name,
			bit_shift: bit_shift
		}
	}
}

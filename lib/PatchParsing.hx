import StringUtils;

@:publicFields
@:structInit
class PatchCsvFormat {
	var address:String;
	var defined:String;
	var minimum:String;
	var maximum:String;
	var name:String;
	var bit_shift:String;

	public static function from_row(columns:Array<String>):PatchCsvFormat {
		return {
			address: columns[0],
			defined: columns[1],
			minimum: columns[2],
			maximum: columns[3],
			name: columns[4],
			bit_shift: columns[5]
		}
	}
}

inline function extract_7_bit_int(data:String):Int {
	return Std.parseInt(data);
}

inline function extract_bit_shift(data:String):Array<Int> {
	var cleaned = strip_all_parenthesis(data);
	var parts = cleaned.split(":");
	if (parts[0] == "bits") {
		// we are parsing a range
		var range = parts[1].split("-");
		var start = Std.parseInt(range[0]);
		var end = Std.parseInt(range[1]) + 1;
		return [for (i in start...end) i];
	}
	return [Std.parseInt(parts[1])];
}

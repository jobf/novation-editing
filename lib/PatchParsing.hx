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

inline function extract_defined(data:String):Int{
	return Std.parseInt(data);
}
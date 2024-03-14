@:structInit
@:publicFields
class PdfDataFormat {
	var section:String;
	var parameter:String;
	var message_type:String;
	var control_number:String;
	var range:String;
	var default_value:String;
	var notes:String;

	static function from_line(csv_line:String):PdfDataFormat {
		var columns = CSV.to_columns(csv_line);
		return {
			section: columns[0],
			parameter: columns[1],
			message_type: columns[2],
			control_number: columns[3],
			range: columns[4],
			default_value: columns[5],
			notes: columns[6]
		}
	}
}

inline function extract_cc_control_number(data:String):Int{
	return Std.parseInt(data);
}

inline function extract_nrpn_control_numbers(data:String):Array<Int>{
	var numbers = data.split(":");
	return [for(item in numbers) Std.parseInt(item)];
}
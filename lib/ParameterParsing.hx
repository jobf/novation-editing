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

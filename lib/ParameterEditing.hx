import ParameterParsing;

@:structInit
@:publicFields
class ParameterEdit {
	var name:String;
	var section:String;
	var minimum_value:Int;
	var maximum_value:Int;
	var default_value:Int;
	var description:String;
	var type:MessageType;
	var control_number:Array<Int>;
	var range_display_offset:Int;


	static function from_pdf_data(data:PdfDataFormat):ParameterEdit {
		var range = extract_range(data.range);
		var range_display_offset = 0;
		if(range.length > 1){
			range_display_offset = range[0][0] + (range[1][0] * -1);
		}

		var message_type:MessageType = switch data.message_type {
			case "CC": CC;
			case _: NRPN;
		}

		var control_number:Array<Int> = switch message_type {
			case CC: [extract_cc_control_number(data.control_number)];
			case NRPN: extract_nrpn_control_numbers(data.control_number);
		}

		var default_value:Int = extract_default(data.default_value);

		return {
			name: data.parameter,
			section: data.section,
			minimum_value: range[0][0],
			maximum_value: range[0][1],
			range_display_offset: range_display_offset, 
			default_value: default_value,
			description: data.notes,
			type: message_type,
			control_number: control_number,
		}
	}

	public function offset_display_value(displayed_value:Int):Int {
		return displayed_value - range_display_offset;
	}
}

enum MessageType {
	CC;
	NRPN;
}

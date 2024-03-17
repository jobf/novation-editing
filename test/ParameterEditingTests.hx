import ParameterEditing;
import ParameterParsing;
import utest.Assert;
import utest.Test;

class ParameterEditingTests extends Test {
	function test_cc_parameter_from_pdf_data() {
		var pdf_data:PdfDataFormat = {
			section: "Voice",
			parameter: "Polyphony Mode",
			message_type: "CC",
			control_number: "3",
			range: "0:2",
			default_value: "2",
			notes: "0=Mono 1=Mono AG 2=Poly"
		}

		var parameter = ParameterEdit.from_pdf_data(pdf_data);

		Assert.same("Voice", parameter.section);
		Assert.same("Polyphony Mode", parameter.name);
		Assert.same(MessageType.CC, parameter.type);
		Assert.same(3, parameter.control_number[0]);
		Assert.same(0, parameter.minimum_value);
		Assert.same(2, parameter.maximum_value);
		Assert.same(2, parameter.default_value);
		Assert.same("0=Mono 1=Mono AG 2=Poly", parameter.description);
	}
	
	function test_nrpn_parameter_from_pdf_data() {
		var pdf_data:PdfDataFormat = {
			section: "LFO",
			parameter: "lfo 1 slew rate",
			message_type: "NRPN",
			control_number: "3:72",
			range: "0:127",
			default_value: "0",
			notes: ""
		}

		var parameter = ParameterEdit.from_pdf_data(pdf_data);

		Assert.same("LFO", parameter.section);
		Assert.same("lfo 1 slew rate", parameter.name);
		Assert.same(MessageType.NRPN, parameter.type);
		Assert.same(3, parameter.control_number[0]);
		Assert.same(72, parameter.control_number[1]);
		Assert.same(0, parameter.minimum_value);
		Assert.same(127, parameter.maximum_value);
		Assert.same(0, parameter.default_value);
		Assert.same("", parameter.description);
	}
}

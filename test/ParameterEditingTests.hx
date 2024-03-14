import ParameterEditing;
import ParameterParsing;
import utest.Assert;
import utest.Test;

class ParameterEditingTests extends Test{

	function test_cc_parameter_from_pdf_data(){
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
}
import haxe.io.Bytes;
import haxe.Resource;
import PatchEditing;
import utest.Assert;
import utest.Test;

class PatchEditingTests extends Test {
	var patch_bytes:Bytes;
	var patch:PatchEdit;

	function setupClass() {
		patch_bytes = Resource.getBytes("CircuitSysExPatchSyx");
		patch = {
			formats: [],
		}

		// patch.dump(patch_bytes);
	}

	function test_read_name() {
		Assert.equals("Acid Square     ", patch.read_name(patch_bytes));
	}

	function test_write_name() {
		var bytes = Bytes.alloc(339);
		var name = "0123456789abcdef";
		patch.write_name(bytes, name);
		var written_name = patch.read_name(bytes);
		Assert.same(name, written_name);
	}
}

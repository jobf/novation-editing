inline function to_lines(text:String):Array<String> {
	return text.split("\n");
}

inline function to_columns(text:String):Array<String> {
	return text.split(",");
}

inline function split_csv_data(csv_file_contents:String):Array<Array<String>> {
	return [for (line in to_lines(csv_file_contents)) to_columns(line)];
}

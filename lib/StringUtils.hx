inline function strip_empty_space(text:String):String {
	return StringTools.replace(text, " ", "");
}

inline function strip_closing_parenthesis(text:String):String {
	return StringTools.replace(text, ")", "");
}

inline function strip_all_parenthesis(text:String):String {
	return strip_closing_parenthesis(StringTools.replace(text, "(", ""));
}

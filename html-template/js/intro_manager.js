function crks_check_hide_intro(_id){
	if($.cookie('crks_hide_intro_' + _id)){
		return true;	
	}
	return false;
}


function crks_hide_intro_by_default(_id){
	$.cookie('crks_hide_intro_' + _id, true, { expires: 360 });
}

function crks_show_intro_by_default(_id){
	$.cookie('crks_hide_intro_' + _id, null);
}
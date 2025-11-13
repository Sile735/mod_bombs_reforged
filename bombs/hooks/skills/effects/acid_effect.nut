::mod_bombs.HooksMod.hook("scripts/skills/effects/acid_effect", function(q) {
	q.applyDamage =  @(__original) function(){		
		if (this.m.LastRoundApplied != this.Time.getRound()){
			__original();
			this.m.LastRoundApplied = this.Time.getRound()-1;
			__original();
		}
	}

})
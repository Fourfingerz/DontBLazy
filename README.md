# DontBLazy

Web app for personal productivity with accountability via shared SMS to friends if you miss a goal.

	CORE FUNCTIONALITY: 
	
	Notes
	July 10, 2015

	. Name a goal, select how many days (1-3) to do it, select recipients
*	. POST a goal. (say 3 days, days_to_complete: 3)
	. Delayed job is set 24 hours
	. After 24 hours,
*		.. days_remaining -= 1 
			.. IF days_remaining > 0
				.. Delayed jobs restarts 24 hour timer
				.. Delayed jobs triggers outbound SMS to account owner's phone
					: Outbound SMS: "Did you do the task for the day?" 
					: Prompt user link to reply via SMS:
						.. YES 
*							: days_completed += 1
						.. NO 
							: Failing SMS is sent to goal's recipients
			.. ELSE days_remaining = 0
				: take days_completed and days_to_complete as TALLY
				: insert TALLY into completion SMS
				: send completion SMS to goal's recipients
				: mark goal as completed: true


		



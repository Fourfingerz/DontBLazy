### MICROPOST FORM
puts "What is your goal?"
$goal = gets.downcase
puts ''
puts "How many days do you want to do your goal?"
$days = gets.to_i
###

### SET VARIABLES 
$days_to_complete = $days
$days_remaining = $days
$current_day = 1
$days_completed = 0
###

for i in ($days).downto(1)
    puts ''
    puts("Today is the #$current_day day" )
    puts("Restarted 24 hour timer") # reboot DELAYED JOB for 24 hours
    puts("Did you complete today's task?") # DJ texts User a PROMPT_SMS 
    reply = gets.chomp.downcase # LOGIC to RECIEVE TEXT MESSAGES FROM TWILIO API
    if reply == "yes"
        puts("Cool! Thank you for being so productive")
        puts ''
        $days_completed += 1
    else
        puts("Your friend failed to complete their goal today")
        puts ''
    end
    $days_remaining -= 1
    $current_day += 1
end

$completion_sms = "Your friend has accomplished their goal of #$goal"
puts "#$completion_sms for #$days_completed out of #$days_to_complete days"
$completed = true
puts("Goal complete? = #$completed")
# Notes

This is a short summary of the project. I completed the challenge and hope I
implemented everything as expected. The Readme file was great and the tips and
tricks section was really helpful. It made the challenge a cool and fun learning
experience. I also really enjoyed the experience of deploying my first app with
Fly.

Deployed app: https://polished-moon-1017.fly.dev/

## What I've built and what I didn't build

I added the missing fields from the `deploymentStatus` and `allocations` to the
`app` query, added some markup to display the information, and added polling to
update the page every 5 seconds with LiveView. That's the simplest and fastest
approach i could come up with to have a working prototype. To keep things
simple, I recreated the experience from `flyctl status --watch` with the same
fields (the information from the App section was already there). If we don't
want all the information from `app` to be polled, we could have also created a
second query.

I followed your advice and didn't work on things you don't care about. I think
if we wanted to polish this feature, then we should write some tests, come up
with a better looking and responsive UI, and improve the error handling. It's
also possible to reduce some of the duplication in the markup with Tailwind's
`@apply` directive, but I didn't do that because the UI is just a prototype.

## What I'd improve or fix if I had more time

Here's a list of ideas on how we could improve the UX:

- Add functionality to perform actions, like stopping and restarting instances
- Add copy to clipboard buttons for IDs and other elements that users frequently
  copy
- Add the ability to sort the instances table by clicking on one of the column
  headers
- Add the ability to filter the instances table
- Add hyperlinks to other pages where it makes sense
- Add more information for terms that are not self explanatory with tooltips for
  example
- Use color coding to improve the visibility of issues and help new users
  understand what is good/bad
- If the instances array is empty, we could display some text and link to the
  documentation on how to deploy

## How I'd determine if this feature is successful

I think a feature's success depends on the problem we are trying to solve. Do we
get too many support tickets from users that are confused about the app status?
Let's track if the number of support tickets decreases that are related to the
app status.

On top of that, it's always a good idea to track basic usage statistics. Since
this web dashboard displays the same information as the `flyctl status` CLI, it
would be interesting to see how many users choose to use the web dashboard over
the CLI. Community feedback is also a great way to get better insights on a
feature's impact on users.

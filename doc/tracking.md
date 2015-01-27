Google Analytics tracking
=========================

Event tracking
--------------

# Modal dialogs

Most modal dialogs on the site should trigger
either a `show` or `hide` action under the
`Popup` category with the `id` of the dialog
as the `label`.

# Search

If the advanced search are shown then a
`toggle` action should be recorded under the
`Search` category.

# Questionnaire

These actions are recorded with `Questionnaire`
as the category.

## Sections

Sections that are collapsed or shown trigger
`show` or `hide` actions with the `id` of the
section as the `label`.

A survey goes through a series of events when
it is started. On the documentationUrl question
page the event action `begin` will be triggered.
With the same identifier code that is in the url
as the `label`.

Once the user continues to the questionnaire page
then a `continue` action will happen.

`save` will happen after pressing the `Save and finish`
button and the user ends up on the dashboard page.

`publish` is the final event after the `Publish certificate`
button.

## Scrolling

Scroll events are recorded when the user moves down
the page significantly. The action is `scroll` with
a label of `page` and the `value` is the percentage
down the page the browser is scrolled.

## Last question

If the user leaves the page by some other means
than pressing the `Save and finish` button then
the last question they clicked on should be recorded
with `last-question` as the action, the text text
of the question as the `label` and the database id
of the question as the `value`.

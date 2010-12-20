Ingredients
=====
Designed for beauty and simplicity, a Cucumber custom formatter. This clean and easy to use Cucumber formatter displays scenarios as they are run, displaying failures as they occur.

I was dissatisfied with existing Cucumber formatters and spent a few hours figuring out the API and dismantling the Pretty formatter in order to create this. Cukeplusplus is inspired by the easy to read colorized output of Emerge, Gentoo’s package manager. Written during a marathon 32-hour coding session, my goal was to reduce the amount of time between running a failing test and being able to work on the bug.

Recipies
======
Use this to quickly spot errors, you'll get the actual error displayed as well as the steps that lead up to it, without the visual noise and scrolling of showing every single step as it executes.

Reagents
====
No dependancies other than Cucumber itself!

    gem install cukeplusplus
    cucumber --format 'Cukeplusplus::Base'

In the Kitchen with Cukeplusplus 
======================
Insert screencast here!

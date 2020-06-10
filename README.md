# Music Garden
 A synesthesic experiment that creates a 3D landscape out of the timbre of an instrument.

## Screenshots



## Artistic concept

I wrote this program after having become obsessed with this idea : *"What could a music look like? Could it be a landscape? Is there a relationship between the auditive quality of the music and its potential visual qualities? Could a visualization be really unique depending on the features of the music?"*. I realized that I wanted to investigate if I could, using Creative Computing, draw a **landscape based on my favorite music** (and allow other people to do the same) and **make it look completely unique** (which is a challenge for all generative art). How amazing would it be, dreamt-I, if we could, in a video game for instance, **find some peace in a garden shaped by the music that most relieves us.** when we’re in trouble, explore it, and play in it. 
This sketch is a *first attempt* toward this aim, but I’m quite happy with these early results.

On a philosophical level, I learned this year from my philosophy course about the Presocratic thinkers about Heraclitus’s *logos*, which is, to simplify, the “rule”, *unintelligible* in its entirety for the human mind, which governs all the of the world's phenomenon as well as explaining why things are as they are. Every phenomenon is thus a **partial expression of it**, a *filtered* intelligible part of this unfathomable unity. There is unintelligibility at music’s core too, and the famous French philosopher Vladimir Jankélévitch even wrote a book called La Musique et l'Ineffable (Ineffable means “unspeakable”). 
How would it be like if my beloved [Mozart’s D minor Concerto](https://www.youtube.com/watch?v=UGldgW6mDnY) was the *logos* of a tiny virtual world? If, instead of the word, it was music “at the beginning”? May the real world’s logos be a divine music? The Ancients may have thought this since Pythagoras, as they believed in something called [Musica Universalis](https://en.wikipedia.org/wiki/Musica_universalis) which is one of my major inspirations, and a broad area for further research to flesh out these ideas.

## Technical Challenges, what I found
First, there is something I found extremely interesting that I certainly hoped, but wasn’t really expecting: **a sound feeling smooth or sweet to the ear generates a smooth landscape, and conversely!** This is a good sign in favour of the plausibility of my extended concept, at least. 
For my experimentation, I wanted to isolate the **waveform** that defines a peculiar instrumental timbre, showing **one cycle of each fundamental wave.** I struggled to do this, but I found a way, not the best for sure, which nevertheless provides good results. It works, which is far better than nothing! A challenge will be to improve this in order to **make the *heightmaps* even more unique**. In the end, I’ve just averaged all the frequencies values during the time of the sample to draw the final timbre signature. I’m sure there are better ways.

With the same input sound file, the gardens generated are different and I think this is due to the framerate. Each frame samples the sound, and this sampling moments are always different. It’s interesting (and relieving) to notice that however different the terrain may be, its global “feel” remains the same for a given timbre.

## What I intended to realize and will do in the future
I wanted to add some noise to increase the terrain’s details in a near future.
Here I focused on the spectrum (the timbre signature to be more precise), but as I’ll learn more about music information retrieval, I will try to add a new phenomenon (as I explained earlier) to this world for each “filtered”, extracted single music feature. I could include some *qualitative features*, (chosen colours maps depending on the musical genre for instance), instead of purely *quantitative parameters*. A good start could be [Spotify’s Track Analysis API](https://developer.spotify.com/documentation/web-api/reference/tracks/), which provides very interesting characteristics of a song, such as its level of *acousticness*, *speachiness*, and *valence*, i.e. the amount of “positive vibes” in a track! The ideas will come in number.

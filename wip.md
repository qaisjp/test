this is a wip issue i am working on. if you read this and then complain to me about its contents, you're a prick.

i said it was WIP, you're not allowed to complain yet


# Establish release/versioning practices

# Glossary
- **"release"**: newly accessible download from mtasa.com, or a (forced) auto-update to users
- **"release revision"**: the source code revision associated with a release
- **"versioned release"**: a public official release, comes along with a new advertised version
- **"nightly"**: a bleeding-edge build of MTA (not necessarily rolled out to users on the nightly stream)
- **"beta features"**: features introduced into `master` (not yet associated with any _versioned release_)
    - e.g. Lua API may not be locked down yet

# Background
Here is what is currently advertised on [nightly.mtasa.com](https://nightly.mtasa.com):

<details><summary>In text form</summary><br>
<pre>
Changes in our repository will
move from the bottom of the list towards the top and finally into the next release:
  (release) <- release candidate <- untested <- unstable
</pre>

<strong>Flavours:</strong>
<ul>
<li>release candidate: builds that contain stable changes. recommended for end-users.</li>
<li>untested: stuff that is waiting to be tested. report your bugs on our bugtracker. recommended for testers.</li>
<li>unstable: bleeding edge developer builds.</li>
<li>experimental: experimental playground for future features.</li>
</details>

![image](https://user-images.githubusercontent.com/923242/58294337-7bc24480-7dc1-11e9-89da-b4a7a1a091b6.png)

## Historical info, pre-Git
If memory serves correctly, we would mark `trunk` as a versioned release. Then trunk would have a new version number and we would continue work on the next major version of MTA (e.g. 1.1).

Occasionally some stuff would be backported from the next major to the next minor, if we even had one (e.g. 1.0.5).

Every so often an `unstable` nightly would be built from `trunk` and users could use this nightly in their own little nightly world. (Don't think there was auto-update? Feel free to edit this issue & correct it.)

**Problems with this**

- New stuff would only end up in the next major 
- The next major would have no players, so it was mostly untested
- You had zero feature updates for a long time

## Current situation, in relation to this

This system is no longer being followed. We now only have one branch `master`, and every night a new _nightly_ is built - these are marked as "release candidate" builds.

Note that these "release candidate" builds are **not** automatically marked as a _release_, they are **not** pushed out to players on the Default update stream.

# Current situation

We tag a _versioned release_ on `master`.

We then merge some cool new features - these new features might not have a stable Lua API, or might have some weird side effects - call 'em _"beta" features_. We also have some awesome bug fixes, like that swimming FPS patch!

- This process creates several nightly builds across several days of commits.
- When we determine that one of these nightly builds have no issues, they are pushed out to players on the "Nightly" build stream.

Oh no, we've found a vulnerability! We fix it on `master` and because it's a vuln, it's important & every player needs to receive this fix. **_We have applied the `hotfix` onto `master`, alongside nightly features._**

Now `master` is turned into a _release_, and we use MTAHQ magic to forcefully push it to every player. (It's untagged in Git.) The download link on _mtasa.com_ homepage also has this release link.

🚨 `master` was turned into a _release_. It has that wonderful bugfix and that very important hotfix. But it also has those _"beta" features_. They seem to function well, and the entire client seems to be stable, but in reality, the API isn't stable. Scripts written against these beta features might break in the future, and we're allowed to break them.

**master should not considered stable, even if the client is stable.**

This contradicts what nightly.mtasa.com defines as a "release candidate" - it should be stable. But it's not!

**"But those features have not been announced yet, so scripters shouldn't use them!"**

That is true. In fact, the wiki lies with its scary black box, and it lies in our favour.

![image](https://user-images.githubusercontent.com/923242/58296228-bed4e580-7dca-11e9-9f1d-6d6bf1ffc4b9.png)

Well... the wiki doesn't know any better. The wiki says certain features _will_ land in `1.5.6 r16361` onwards. It doesn't know that we're on `1.5.6 r16588`, and that they have already landed.

Should it say _"From 1.5.7 onwards"_ instead? Maybe.

**Browser wars**

The very practice of introducing "incomplete" features into HTML and CSS is what caused issues with browser compatibility. It's why feature flags exist in browsers today.

(I say "incomplete" because we can change its behaviour whenever we like, as long as we do it before a versioned release. We still have time to respond to user feedback and iron out some bugs.)

We're not competing with other browsers, so we only have half the problem.

But a scripter would expect resources they write on a release build to _continue_ working virtually forever. (That's the whole point of MTA's backwards compat.) We break that guarantee by introducing "incomplete" features in _releases_.

Feature flags would be an interesting addition to MTA, but _might_ be difficult to actually apply properly.

**Are you saying 

- It is not possible to determine (via Git) which commit is an actual release.
- Currently bleeding-edge builds are being considered "stable", and turned into "releases"
    - This process is undocumented, unadvertised, and not reflected within Git
    - 

# What we were supposed to do

When we moved over to Git, we were supposed to begin doing more frequent releases. This means that we would just develop on `master` and those hotfixes would come out as releases anyway.

We haven't really sped up with our releases!


**Requirements for a new solution**

- Important hotfixes need to be instantly rolled out, in case of emergency only
    - e.g. we fucked up BitStream
    - e.g. some lvl9 wizard net module stuff
- For the majority of players, features that have not been finalised should only end up in the next official release
- To discuss: bugfixes can wait until the next release (swimming FPS fix)
    - Personally I think most fixes can wait until the next release. We can just do frequent releases... pre-summer, post-summer and Christmas releases?


**Solution B: "MTA as **

Switch over to and hide public versions entirely (a la Chrome). Or do releases much more frequently with ever increasing version numbers. 

**Suggested solution**

- `develop` - where all new features are developed
- `release` - where `v1.5.5`, `v.1.5.6-x`, `v.1.5.7`, etc

**At the very least...**
if we don't change anything, can we at least document these practices somewhere and introduce Git tagging?

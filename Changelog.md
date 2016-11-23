# Changelog

**1.7.1-1**
 - Added fix so ~/.docker directory will be saved to data directory for permanent storage.
   This allows logins to be cached so runner will be able to access private repositories
   without having credentials being saved into build file like .gitlab-ci.yml

**1.7.1**
 - Initial Creation
 - GitLab Runner Rename, all references in name concerning *ci* and/or *multi* are now dropped.
   [https://gitlab.com/gitlab-org/gitlab-ci-multi-runner#gitlab-runner](More Information)
 - Based upon sameersbn/ubuntu:latest
 -- Auto rebuild on remote repository push
 - Include docker socket support
 - Added easy repository tag change with ```REPOSITORY``` file
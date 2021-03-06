#!/usr/bin/env bash
cd $(dirname $0)/..
PROJECT="mars"
IMPORT_URL="https://subversion.makina-corpus.net/scrumpy/mars"
cd $(dirname $0)/..
[[ ! -d t ]] && mkdir t
rm -rf t/*
tar xzvf $(ls -1t ~/cgwb/$PROJECT*z) -C t
files="
.gitignore
bootstrap.py
buildout-dev.cfg
buildout-prod.cfg
minitage.buildout-dev.cfg
minitage.buildout-prod.cfg
README.*
etc/
minilays/
"
for f in $files;do
    rsync -aKzv t/$f $f
done
policy="tests/base.py
configure.zcml
profiles/default/metadata.xml"
policy_folder="src.mrdeveloper/$PROJECT.policy"
if [[ ! -e $policy_folder ]];then
    policy_folder="src/$PROJECT.policy"
fi
for i in $policy;do
    rsync -azKv t/src/$PROJECT.policy/src/$PROJECT/policy/$i src.mrdeveloper/$PROJECT.policy/src/$PROJECT/policy/$i
done
EGGS_IMPORT_URL="$IMPORT_URL/eggs"
sed -re "/\[sources\]/{
        a $PROJECT.policy =  svn $EGGS_IMPORT_URL/$PROJECT.policy/trunk
        a $PROJECT.skin =    svn $EGGS_IMPORT_URL/$PROJECT.skin/trunk
        a $PROJECT.tma =     svn $EGGS_IMPORT_URL/$PROJECT.tma/trunk
        a $PROJECT.testing = svn $EGGS_IMPORT_URL/$PROJECT.testing/trunk
        a bibliograph.core           = svn https://subversion.makina-corpus.net/scrumpy/mars/eggs/bibliograph.core/trunk
        a bibliograph.parsing        = svn https://subversion.makina-corpus.net/scrumpy/mars/eggs/bibliograph.parsing/trunk
        a bibliograph.rendering      = svn https://subversion.makina-corpus.net/scrumpy/mars/eggs/bibliograph.rendering/trunk
        a marsapp.bibliography       = svn https://subversion.makina-corpus.net/scrumpy/mars/eggs/marsapp.bibliography/trunk
        a marsapp.csvreplicata       = svn https://subversion.makina-corpus.net/scrumpy/mars/eggs/marsapp.csvreplicata/trunk
        a marsapp.categories         = svn https://subversion.makina-corpus.net/scrumpy/mars/eggs/marsapp.categories/trunk
        a marsapp.content            = svn https://subversion.makina-corpus.net/scrumpy/mars/eggs/marsapp.content/trunk
        a marsapp.helpers            = svn https://subversion.makina-corpus.net/scrumpy/mars/eggs/marsapp.helpers/trunk
        a marsapp.migration          = svn https://subversion.makina-corpus.net/scrumpy/mars/eggs/marsapp.migration/trunk
        a marsapp.policy             = svn https://subversion.makina-corpus.net/scrumpy/mars/eggs/marsapp.policy/trunk
        a Products.CMFBibliographyAT = svn https://subversion.makina-corpus.net/scrumpy/mars/eggs/Products.CMFBibliographyAT/trunk 
}" -i  etc/project/sources.cfg
sed -re "s:(src/)?$PROJECT\.((skin)|(tma)|(policy)|(testing))::g" -i etc/project/$PROJECT.cfg
sed -re "/auto-checkout \+=/{
        a \    $PROJECT.policy
        a \    $PROJECT.tma
        a \    $PROJECT.skin
        a \    $PROJECT.testing
        a \    bibliograph.core           
        a \    bibliograph.parsing        
        a \    bibliograph.rendering      
        a \    marsapp.bibliography       
        a \    marsapp.categories         
        a \    marsapp.csvreplicata         
        a \    marsapp.content            
        a \    marsapp.helpers            
        a \    marsapp.migration          
        a \    marsapp.policy             
        a \    Products.CMFBibliographyAT 
}"  -i etc/project/sources.cfg
sed -re "/eggs \+=.*buildout:eggs/{
        a \    $PROJECT.policy
        a \    $PROJECT.tma
        a \    $PROJECT.skin
        a \    $PROJECT.testing
        a \    bibliograph.core           
        a \    bibliograph.parsing        
        a \    bibliograph.rendering      
        a \    marsapp.bibliography       
        a \    marsapp.categories         
        a \    marsapp.content            
        a \    marsapp.csvreplicata            
        a \    marsapp.helpers            
        a \    marsapp.migration          
        a \    marsapp.policy             
        a \    Products.CMFBibliographyAT 
}"  -i etc/project/$PROJECT.cfg
sed -re "/zcml \+=/{
        a \    $PROJECT.policy
        a \    $PROJECT.tma
        a \    $PROJECT.skin
        a \    bibliograph.core           
        a \    bibliograph.parsing        
        a \    bibliograph.rendering      
        a \    marsapp.bibliography       
        a \    marsapp.categories         
        a \    marsapp.csvreplicata         
        a \    marsapp.content            
        a \    marsapp.helpers            
        a \    marsapp.migration          
        a \    marsapp.policy             
        a \    Products.CMFBibliographyAT 
}"  -i etc/project/$PROJECT.cfg
sed -re "s/.*:default/    ${PROJECT}.policy:default/g" -i  etc/project/$PROJECT.cfg
sed -re "s/(extends=.*)/\1 etc\/sys\/settings-prod.cfg/g" -i buildout-prod.cfg
sed -re "/\[buildout\]/ {
aallow-hosts = \${mirrors:allow-hosts}
}" -i etc/base.cfg
sed -re "/\[mirrors\]/ {
aallow-hosts =
a\     *localhost*
a\     *willowrise.org*
a\     *plone.org*
a\     *zope.org*
a\     *effbot.org*
a\     *python.org*
a\     *initd.org*
a\     *googlecode.com*
a\     *plope.com*
a\     *bitbucket.org*
a\     *repoze.org*
a\     *crummy.com*
a\     *minitage.org*
a\     *bpython-interpreter.org*
a\     *www.riverbankcomputing.com*
a\     *.selenic.com*
}" -i etc/sys/settings.cfg
sed  -re "s/dependencies=/dependencies=git-1.7 subversion-1.6 /g" -i minilays/*/*
# vim:set et sts=4 ts=4 tw=80:

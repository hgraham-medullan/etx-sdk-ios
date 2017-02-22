echo "Generating new docs..."
jazzy --min-acl public 
echo "Launching new docs.."
open docs/index.html
echo "Opened new docs in your browser"

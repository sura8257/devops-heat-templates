import yaml
import argparse
import sys


command_defaults = {
  "validation_key": '\"$(< ~/chef-repo/.chef/anzdevops-validator.pem)\"',
  "organization": "anzdevops",
  "run_list": "\'\"recipe[rackops_rolebook]\"\'",
  "chef_server_url": None,
  "connected_network": None
}

parser = argparse.ArgumentParser(description="Generate README.md for a given heat template")
parser.add_argument('template')

args = parser.parse_args()

try:
  template_stream = open(args.template, 'r')
  hot = yaml.load(template_stream)
except:
  print 'Unable to load template'
  sys.exit(1)


output = []

output.append('# %s' % args.template)

#################
output.append('')
output.append('## Description')
output.append(hot['description'])

#################
output.append('')
output.append('## Parameters')


default_params = []
################
output.append('')
for param in hot['parameters']:
  output.append('* %s' % hot['parameters'][param]['label'])
  output.append('  * Name: %s' % param)
  try:

    if hot['parameters'][param]['default'] == '':
      output.append('  * Default: empty string')
      def_param = ''
    else:
      output.append('  * Default: %s' % hot['parameters'][param]['default'])
      def_param = hot['parameters'][param]['default']
  

    try:
      if command_defaults[param] != None:
        default_params.append('%s=%s' % (param, command_defaults[param]) )
    except:
      default_params.append('%s=%s' % (param, def_param) )
  except:
    pass
    
  try: 
    output.append('  * Description: %s' % hot['parameters'][param]['description']).rstrip("\n")
  except:
    pass

  try:
    output.append('  * Possible Values: ```%s```' % ', '.join(hot['parameters'][param]['constraints'][0]['allowed_values']))
  except: 
    pass

#################
output.append('')
output.append('## Resources to be deployed')

for res in hot['resources']:
  output.append('* %s: %s' %(res, hot['resources'][res]['type']))

#################
output.append('')
output.append('# Example Usage')
output.append('```supernova heat-rc3 -x heat stack-create -P %s -f %s -e env-2net.yaml stack-name ```' %(" -P ".join(default_params), args.template))

################
print "\n".join(output)

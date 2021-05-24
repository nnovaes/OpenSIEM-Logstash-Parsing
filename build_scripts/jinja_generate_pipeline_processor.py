import jinja2
import json
import os


template_file = "config/pipeline_processor.j2"
json_parameter_file = "temp_postjq_pipelines.json"
output_directory = "."

# read the contents from the JSON files
print("Read JSON parameter file...")
config_parameters = json.load(open(json_parameter_file))

# next we need to create the central Jinja2 environment and we will load
# the Jinja2 template file (the two parameters ensure a clean output in the
# configuration file)
print("Create Jinja2 environment...")
env = jinja2.Environment(loader=jinja2.FileSystemLoader(searchpath=".."),
                         trim_blocks=True,
                         lstrip_blocks=True,
                         extensions=["jinja2_getenv_extension.GetenvExtension"])


template = env.get_template(template_file)

# we will make sure that the output directory exists
if not os.path.exists(output_directory):
    os.mkdir(output_directory)

result = template.render(data=config_parameters)
f = open(os.path.join(output_directory, "../config/pipeline_processor.yml"), "w")
f.write(result)
f.close()


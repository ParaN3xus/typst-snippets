import os
import shutil
import subprocess
import re

def clean_readme(file_path):
    if not os.path.exists(file_path):
        return
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    new_content = re.split(r'\n## Example.*', content)[0]
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(new_content)

def compile_typst(folder_path):
    example_path = os.path.join(folder_path, 'example')
    if os.path.exists(example_path):
        shutil.rmtree(example_path)
    os.makedirs(example_path)
    
    subprocess.run(['typst', 'compile', '--font-path', '../fonts', '--root', folder_path, 
                   os.path.join(folder_path, 'example.typ'), 
                   os.path.join(example_path, '{n}.png')])
    


def update_folder_readme(folder_path, folder_name):
    readme_path = os.path.join(folder_path, 'README.md')
    example_path = os.path.join(folder_path, 'example')
    
    png_files = sorted([f for f in os.listdir(example_path) if f.endswith('.png')])
    
    example_content = "\n## Example\n<details>\n<summary>Click to expand</summary>\n\n"
    for png in png_files:
        example_content += f"![{png.replace('.png', '')}](https://raw.githubusercontent.com/ParaN3xus/typst-snippets/refs/heads/main/{folder_name}/example/{png})\n\n"
    example_content += "</details>"
    
    with open(readme_path, 'a', encoding='utf-8') as f:
        f.write(example_content)

def update_main_readme(folders):
    with open('README.md', 'r', encoding='utf-8') as f:
        content = f.read()
    
    content = re.split(r'\n## Contents.*?(?=\n#|$)', content, flags=re.DOTALL)[0]
    
    contents = "\n## Contents\n\n"
    for folder in sorted(folders):
        contents += f"- [{folder}](https://github.com/ParaN3xus/typst-snippets/tree/main/{folder})\n"
    
    with open('README.md', 'w', encoding='utf-8') as f:
        f.write(content + contents)

def main():
    valid_folders = []
    for item in os.listdir('.'):
        if os.path.isdir(item) and \
           os.path.exists(os.path.join(item, 'README.md')) and \
           os.path.exists(os.path.join(item, 'example.typ')):
            valid_folders.append(item)
    
    for folder in valid_folders:
        print(f"Processing {folder}...")
        clean_readme(os.path.join(folder, 'README.md'))
        compile_typst(folder)
        update_folder_readme(folder, folder)
    
    update_main_readme(valid_folders)

if __name__ == '__main__':
    main()

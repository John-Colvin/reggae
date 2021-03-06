from __future__ import (unicode_literals, division,
                        absolute_import, print_function)


import json
import argparse


def get_json(module):
    from reggae.reflect import get_build, get_default_options, get_dependencies
    build = get_build(module)
    default_opts = get_default_options(module)
    opts_json = {} if default_opts is None else default_opts.jsonify()
    ret = {'version': 1,
           'defaultOptions': opts_json,
           'dependencies': get_dependencies(module.__file__),
           'build': build.jsonify()}

    return json.dumps(ret)


def main():
    parser = argparse.ArgumentParser(description='oh hello')
    parser.add_argument('--options', type=json.loads, default=dict())
    parser.add_argument('project_path', help='The project path')
    args = parser.parse_args()

    from reggae import set_options
    set_options(args.options)

    import sys
    sys.path.append(args.project_path)
    import reggaefile
    print(get_json(reggaefile))


if __name__ == '__main__':
    main()

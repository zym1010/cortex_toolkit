"""Generate stereograms in batch."""

# Yimeng Zhang
# Computer Science Department, Carnegie Mellon University
# zym1010@gmail.com

import sys
import argparse
import os.path

def generate_stereogram_batch(args):
    if args.execdir:
        sys.path.append(args.execdir)
        # print(args.execdir)

    import generate_one_stereogram
    assert args.numframes >= 1

    argstemplate = args


    for iFrame in xrange(args.numframes):
        frameSuffix = str(iFrame+1)
        argsThis = argstemplate
        argsThis.matfile = os.path.join(argstemplate.matdir,argstemplate.matfileprefix + 'L' + frameSuffix + '.mat')
        # print(argsThis.matfile)
        argsThis.output = os.path.join(argstemplate.imgdir,argstemplate.matfileprefix + 'L' + frameSuffix + '.png')
        # print(argsThis.output)
        generate_one_stereogram.generate_one_stereogram(argsThis)
        argsThis.matfile = os.path.join(argstemplate.matdir,argstemplate.matfileprefix + 'R' + frameSuffix + '.mat')
        argsThis.output = os.path.join(argstemplate.imgdir,argstemplate.matfileprefix + 'R' + frameSuffix + '.png')
        generate_one_stereogram.generate_one_stereogram(argsThis)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Generate one stereogram, batch')
    parser.add_argument('matfileprefix', help = 'MAT file saving info for dots')
    parser.add_argument("--halfwidth", help = "half width of the stereogram in cm", type = float, required=True)
    parser.add_argument("--halfheight", help = "half height of the stereogram in cm", type = float, required=True)
    parser.add_argument("--verbose", help="increase output verbosity",action="store_true")
    parser.add_argument("--ppc", help="pixels per cm", type = float, default=700/32.9)  # or inverse?
    parser.add_argument("--radius", help="radius of dots in cm", type = float, default=0.045)
    parser.add_argument("--output", help="name of output file", default='output.png')
    parser.add_argument("--margin", help="margin of output in cm", type=float, default=0.045)
    parser.add_argument("--bkgcolor", help="background color in [0,1]", type=float, default=0.375)
    parser.add_argument("--numframes", help="number of frames", type=int, default=1)
    parser.add_argument("--imgdir", help="dir saving images", default='.')
    parser.add_argument("--matdir", help="dir loading mats", default='.')
    parser.add_argument("--resizeheight", help="resize height to half", action="store_true")

    parser.add_argument("--execdir", help="dir of executable")
    args = parser.parse_args()
    generate_stereogram_batch(args)

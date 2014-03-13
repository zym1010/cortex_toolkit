"""Generate one stereogram."""

# Yimeng Zhang
# Computer Science Department, Carnegie Mellon University
# zym1010@gmail.com
from OpenGL.GL import *
from OpenGL.GLUT import *
from OpenGL.GLU import *
import numpy as np
import Image
import argparse
import scipy.io as sio
import math

def generate_one_stereogram(args):
    bkgcolor = args.bkgcolor
    # print args.margin

    width = int(2*math.ceil( (args.halfwidth + args.margin) * args.ppc) )
    height = int(2*math.ceil(  (args.halfheight + args.margin) * args.ppc) )

    # half versions are for matrix
    halfwidth = (width/2) / args.ppc
    halfheight = (height/2) / args.ppc

    # print halfwidth
    # print halfheight

    assert abs(halfwidth*args.ppc*2 - width) <  1e-6
    assert abs(halfheight*args.ppc*2 - height) < 1e-6

    if args.resizeheight:
        height = height//2
    # load mat file
    mat_contents = sio.loadmat(args.matfile)
    assert 'surfaces' in mat_contents.keys()
    surfaces = mat_contents['surfaces'].copy()


    assert surfaces.shape[1] == 1
    nSurfaces = surfaces.shape[0]

    if args.verbose:
        print("{} surfaces in total.".format(nSurfaces))






    angles = np.arange(0,361)
    angles = np.radians(angles)
    template_positions = np.column_stack((np.cos(angles), np.sin(angles)))
    # create the vertex arrays and color arrays for use.
    def create_vertex_array(position, radius):
        vertex_array = radius*template_positions + position
        vertex_array = np.row_stack((position,vertex_array))
        vertex_array.shape = (362,2)
        return vertex_array


    angles_square = [45,135,225,315,45]
    angles_square = np.radians(angles_square)
    template_positions_square = np.column_stack((np.cos(angles_square), np.sin(angles_square)))

    def create_vertex_array_square(position, radius):
        vertex_array = np.sqrt(2)*radius*template_positions_square + position
        vertex_array = np.row_stack((position,vertex_array))
        vertex_array.shape = (6,2)
        return vertex_array

    def create_surface_box_vertex_array(cornerPositions):
        box_enter = np.mean(cornerPositions,0) # the center of the bounding box.
        vertex_array = np.row_stack((box_enter, cornerPositions, cornerPositions[0,:] ))
        return vertex_array







    vertexArrayListList = []
    surfaceBoxList = []
    NList = []
    colorsList = []
    for iSurface in xrange(nSurfaces):
        thisSurface = surfaces[iSurface,0][0,0]
        positions = thisSurface['positions'].copy()
        colors = thisSurface['colors'].copy()
        cornerPositions = thisSurface['cornerPositions'].copy()
        
        assert colors.shape[0] == positions.shape[0], 'different lengths for colors and positions'
        assert colors.shape[1] == 1 or colors.shape[1] == 3
        assert positions.shape[1] == 2
        assert cornerPositions.shape == (4,2)
        NthisSurface = colors.shape[0]
        NList.append(NthisSurface)
        if args.verbose:
            print("{} points in total.".format(NthisSurface))
        if colors.shape[1] == 1:   # expand color to 3d points if needed
            colors = np.tile(colors,(1,3))
        if args.verbose:
            print("grayscale color used.")

        assert(colors.shape[1] == 3)
        colorsList.append(colors)
        vertexArrayList = list()
        for i in xrange(NthisSurface):
            # vertexArrayList.append( create_vertex_array( positions[i,:],args.radius )  )
            vertexArrayList.append( create_vertex_array_square( positions[i,:],args.radius )  )
        vertexArrayListList.append(vertexArrayList)
        surfaceBoxList.append( create_surface_box_vertex_array(cornerPositions) )









    window = 0                                              # glut window number


    def draw():

                                    # ondraw is called all the time
        glClearColor(bkgcolor, bkgcolor, bkgcolor, 1.0);                  # Set background color to gray
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT) # clear the screen
        # glLoadIdentity()                                   # reset position


        for iSurface in xrange(nSurfaces):
            # if iSurface == 0:
            #     glColor(1.0,0,0) # gray 
            # if iSurface == 1:
            #     glColor(0,1,0) # gray 
            # if iSurface == 2:
            #     glColor(0,0,1) # gray 
            glColor(bkgcolor,bkgcolor,bkgcolor) # gray 
            glEnableClientState(GL_VERTEX_ARRAY)
            glVertexPointerd(surfaceBoxList[iSurface])
            glDrawArrays(GL_TRIANGLE_FAN, 0, surfaceBoxList[iSurface].shape[0])
            glDisableClientState(GL_VERTEX_ARRAY)
            colorsThis = colorsList[iSurface]
            for i in xrange(NList[iSurface]):
                glColor(colorsThis[i,0],colorsThis[i,1],colorsThis[i,2])
                glEnableClientState(GL_VERTEX_ARRAY)
                glVertexPointerd(vertexArrayListList[iSurface][i])
                # glDrawArrays(GL_TRIANGLE_FAN, 0, 362)
                glDrawArrays(GL_TRIANGLE_FAN, 0, vertexArrayListList[iSurface][i].shape[0])
                glDisableClientState(GL_VERTEX_ARRAY)

        # writing image...
        # data = glReadPixels( 0,0, int(width), int(height), GL_RGBA, GL_UNSIGNED_BYTE)
        # image = Image.frombuffer("RGBA", (width,height), data, "raw", "RGBA", 0, 0)
        # image.save(args.output)
        # exit(0) # only write one frame

        #glutSwapBuffers()                                  # important for double buffering


    # initialization

    glutInit()                                             # initialize glut

    glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_ALPHA | GLUT_DEPTH)
    glutInitWindowSize(1, 1)                      # set window size
    #glutInitWindowPosition(0, 0)                           # set window position
    window = glutCreateWindow("OpenGL Setup Test")              # create window with title
    glutHideWindow()
    glHint(GL_LINE_SMOOTH_HINT, GL_NICEST)
    glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST)
    # glEnable( GL_POLYGON_SMOOTH )
    # glEnable( GL_LINE_SMOOTH )

    color = glGenTextures(1);
    glBindTexture(GL_TEXTURE_2D, color);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, None);

    depth = glGenRenderbuffers(1);
    glBindRenderbuffer(GL_RENDERBUFFER, depth);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT, width, height);

    fbo = glGenFramebuffers(1);
    glBindFramebuffer(GL_FRAMEBUFFER, fbo);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, color, 0);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depth);

    # print 'actual:', glCheckFramebufferStatus(GL_FRAMEBUFFER)
    # print 'expected:', int(GL_FRAMEBUFFER_COMPLETE)

    # offscreen = True

    glBindFramebuffer(GL_FRAMEBUFFER, fbo)
    glPushAttrib(GL_VIEWPORT_BIT)
    glPushAttrib(GL_TRANSFORM_BIT)
    glViewport(0,0,width, height)
    gluOrtho2D(-halfwidth, halfwidth, -halfheight, halfheight)
    draw()
    glPopAttrib()
    glPopAttrib()


    glBindFramebuffer(GL_FRAMEBUFFER, fbo)
    data = glReadPixels( 0,0, int(width), int(height), GL_RGBA, GL_UNSIGNED_BYTE)
    image = Image.frombuffer("RGBA", (width,height), data, "raw", "RGBA", 0, 0)

    

    image.save(args.output)
    return # only write one frame

    # glutDisplayFunc(draw)                                  # set draw function callback
    # glutMainLoop()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Generate one stereogram.')

    parser.add_argument('matfile', help = 'MAT file saving info for dots')
    parser.add_argument("--halfwidth", help = "half width of the stereogram in cm", type = float, required=True)
    parser.add_argument("--halfheight", help = "half height of the stereogram in cm", type = float, required=True)
    parser.add_argument("--verbose", help="increase output verbosity",action="store_true")
    parser.add_argument("--ppc", help="pixels per cm", type = float, default=700/32.9)  # or inverse?
    parser.add_argument("--radius", help="radius of dots in cm", type = float, default=0.045)
    parser.add_argument("--output", help="name of output file", default='output.png')
    parser.add_argument("--margin", help="margin of output in cm", type=float, default=0.045)
    parser.add_argument("--bkgcolor", help="background color in [0,1]", type=float, default=0.375)
    parser.add_argument("--resizeheight", help="resize height to half", action="store_true")

    args = parser.parse_args()
    generate_one_stereogram(args)

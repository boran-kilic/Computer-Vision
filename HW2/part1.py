import numpy as np
import cv2 as cv
from matplotlib import pyplot as plt

book_names = ['automata.jpeg', 'c.jpeg', 'cleancode.jpeg','cs.jpeg', 'cv.jpeg',
               'fn.jpeg', 'machineage.jpeg','noname.png', 'os.jpeg','petrol.jpeg',
              'proofs.jpeg','soul.jpeg', 'strip.png','topology.jpeg','understory.jpeg'
              ]

book_name = book_names[9]

img_path_rotated = f'part1/rotated_img_new/rotated_{book_name}'
img_path= f'part1/img/{book_name}'


def cannyedgedetection(file_path, lower_threshold = 1, upper_threshold=50):
    img_color = cv.imread(file_path, cv.IMREAD_COLOR)
    assert img_color is not None, "file could not be read, check with os.path.exists()"
    img_color = cv.cvtColor(img_color, cv.COLOR_BGR2RGB)
    
    paddingsize = 5
    img_color = cv.copyMakeBorder(img_color, paddingsize, paddingsize, paddingsize, paddingsize, cv.BORDER_CONSTANT, value=[0,0,0])
    img_gray = cv.cvtColor(img_color, cv.COLOR_RGB2GRAY)
        
    blurred_img = cv.GaussianBlur(img_gray, (15, 15), 1.4)
    edges = cv.Canny(blurred_img, lower_threshold, upper_threshold, apertureSize=3, L2gradient=True)

    return img_color, edges

def houghtransform(img_color, edges, threshold=50, minLineLength=150, maxLineGap=15, num_bins = 20):
        #Hough Transform parameters
    lines_list = []
    lines = cv.HoughLinesP(
        edges,  # Input edge image
        2,  # Distance resolution in pixels
        np.pi/180,  # Angle resolution in radians
        threshold=threshold,  # Min number of votes for valid line
        minLineLength=minLineLength,  # Min allowed length of line
        maxLineGap=maxLineGap  # Max allowed gap between line for joining them
    )

    img_line = img_color.copy()

    orientations = []  # Angles
    weights = []       # Line lengths

    if lines is None:
        print("No lines detected")
    else:    
        for points in lines:
            x1, y1, x2, y2 = points[0]
            cv.line(img_line, (x1, y1), (x2, y2), (0, 255, 0), 2)
            
            # Compute orientation (angle) in radians
            angle = np.arctan2(y2 - y1, x2 - x1)
            if angle < 0:
                angle += np.pi  # Map angles from [-pi, 0] to [0, pi]
            elif angle == np.pi:
                angle = 0  # Map pi to 0
            orientations.append(angle)
            
            # Compute line length
            length = np.sqrt((x2 - x1)**2 + (y2 - y1)**2)
            weights.append(length)
            
            lines_list.append([(x1, y1), (x2, y2)])

        # Line fitting results
        plt.figure()
        plt.subplot(121), plt.imshow(img_line)
        plt.title('Line Fitting'), plt.xticks([]), plt.yticks([])
        plt.pause(0.001) 

        # print("number of lines detected: ", len(lines_list))
        
        # Create histogram bins
        
        bin_edges = np.linspace(0, np.pi, num_bins + 1) 

        # Compute histogram
        hist, bin_edges = np.histogram(orientations, bins=bin_edges, weights=weights)

        # Plot the histogram
        # plt.figure()
        plt.subplot(122)
        plt.bar((bin_edges[:-1] + bin_edges[1:]) / 2, hist, width=np.diff(bin_edges), edgecolor="black", align="center")
        plt.xlabel("Orientation (radians)")
        plt.ylabel("Weighted Count")
        plt.title("Line Orientation Histogram")

        xticks = [ 0, np.pi/4, np.pi/2, 3*np.pi/4, np.pi]
        xtick_labels = [ r'$0$', r'$\pi/4$', r'$\pi/2$', r'$3\pi/4$', r'$\pi$']
        plt.xticks(xticks, xtick_labels)

        plt.pause(0.001) 

    return hist    

plt.ion()

book_name = book_names[9]

img_path_rotated = f'part1/rotated_img_new/rotated_{book_name}'
img_path= f'part1/img/{book_name}'

img_color, edges = cannyedgedetection(img_path, lower_threshold = 1, upper_threshold=50)
# Edge Detection
plt.figure()
plt.subplot(121), plt.imshow(img_color)
plt.title('Original Image'), plt.xticks([]), plt.yticks([])
plt.subplot(122), plt.imshow(edges, cmap='gray')
plt.title('Edge Image'), plt.xticks([]), plt.yticks([])     
plt.pause(0.001)

img_color, edges = cannyedgedetection(img_path, 150, 250)
# Edge Detection
plt.figure()
plt.subplot(121), plt.imshow(img_color)
plt.title('Original Image'), plt.xticks([]), plt.yticks([])
plt.subplot(122), plt.imshow(edges, cmap='gray')
plt.title('Edge Image'), plt.xticks([]), plt.yticks([])     
plt.pause(0.001)

book_name = book_names[5]
img_path_rotated = f'part1/rotated_img_new/rotated_{book_name}'
img_path= f'part1/img/{book_name}'
img_color, edges = cannyedgedetection(img_path, lower_threshold = 1, upper_threshold=50)
hist = houghtransform(img_color, edges, threshold=50, minLineLength=150, maxLineGap=15, num_bins = 20 )

book_name = book_names[0]
img_path_rotated = f'part1/rotated_img_new/rotated_{book_name}'
img_path= f'part1/img/{book_name}'
img_color, edges = cannyedgedetection(img_path, lower_threshold = 1, upper_threshold=50)
hist = houghtransform(img_color, edges, threshold=50, minLineLength=150, maxLineGap=15, num_bins = 20 )

book_name = book_names[14]
img_path_rotated = f'part1/rotated_img_new/rotated_{book_name}'
img_path= f'part1/img/{book_name}'
img_color, edges = cannyedgedetection(img_path, lower_threshold = 1, upper_threshold=50)
hist = houghtransform(img_color, edges, threshold=50, minLineLength=150, maxLineGap=15, num_bins = 20 )

book_name = book_names[9]

img_path_rotated = f'part1/rotated_img_new/rotated_{book_name}'
img_path= f'part1/img/{book_name}'

img_color, edges = cannyedgedetection(img_path, lower_threshold = 1, upper_threshold=50)
hist = houghtransform(img_color, edges, threshold=50, minLineLength=150, maxLineGap=15, num_bins = 50 )
hist = houghtransform(img_color, edges, threshold=50, minLineLength=150, maxLineGap=15, num_bins = 20 )
hist = houghtransform(img_color, edges, threshold=50, minLineLength=150, maxLineGap=15, num_bins = 5)


def linehistogram(file_path, num_bins = 20):
    img_color = cv.imread(file_path, cv.IMREAD_COLOR)
    assert img_color is not None, "file could not be read, check with os.path.exists()"
    img_color = cv.cvtColor(img_color, cv.COLOR_BGR2RGB)
    
    paddingsize = 5
    img_color = cv.copyMakeBorder(img_color, paddingsize, paddingsize, paddingsize, paddingsize, cv.BORDER_CONSTANT, value=[0,0,0])
    img_gray = cv.cvtColor(img_color, cv.COLOR_RGB2GRAY)
        
    blurred_img = cv.GaussianBlur(img_gray, (15, 15), 1.4)
    edges = cv.Canny(blurred_img, 1, 50, apertureSize=3, L2gradient=True)
 
    #Hough Transform parameters
    lines_list = []
    lines = cv.HoughLinesP(
        edges,  # Input edge image
        2,  # Distance resolution in pixels
        np.pi/180,  # Angle resolution in radians
        threshold=50,  # Min number of votes for valid line
        minLineLength=150,  # Min allowed length of line
        maxLineGap=15  # Max allowed gap between line for joining them
    )

    img_line = img_color.copy()

    orientations = []  # Angles
    weights = []       # Line lengths

    if lines is None:
        print("No lines detected")
    else:    
        for points in lines:
            x1, y1, x2, y2 = points[0]
            cv.line(img_line, (x1, y1), (x2, y2), (0, 255, 0), 2)
            
            # Compute orientation (angle) in radians
            angle = np.arctan2(y2 - y1, x2 - x1)
            if angle < 0:
                angle += np.pi  # Map angles from [-pi, 0] to [0, pi]
            elif angle == np.pi:
                angle = 0  # Map pi to 0
            orientations.append(angle)
            
            # Compute line length
            length = np.sqrt((x2 - x1)**2 + (y2 - y1)**2)
            weights.append(length)
            
            lines_list.append([(x1, y1), (x2, y2)])
        
        # Create histogram bins
        
        bin_edges = np.linspace(0, np.pi, num_bins + 1) 

        # Compute histogram
        hist, bin_edges = np.histogram(orientations, bins=bin_edges, weights=weights)

    return hist


def find_rotation_angle(rotated_hist, original_histograms):
    min_distance = float('inf')
    best_match = None
    best_shift = 0
    
    # Iterate through the original histograms
    for i, original_hist in enumerate(original_histograms):
        # Try circular shifts from 0 to len(hist) - 1
        for shift in range(len(rotated_hist)):
            shifted_rotated_hist = np.roll(rotated_hist, shift)
            distance = np.linalg.norm(shifted_rotated_hist - original_hist)
            
            # If this is the best match so far, store it
            if distance < min_distance:
                min_distance = distance
                best_match = i
                best_shift = shift
                
    # The angle of rotation is proportional to the shift
    angle_of_rotation = (best_shift / len(rotated_hist)) * np.pi
    return best_match, angle_of_rotation

# Create a list of histograms for the original books
original_histograms = []
for book_name in book_names:
    img_path = f'part1/img/{book_name}'
    hist = linehistogram(img_path)
    original_histograms.append(hist)
number_of_matches = 0
# Now, loop through each rotated book and find the match
for rotated_book in book_names:
    rotated_img_path = f'part1/rotated_img_new/rotated_{rotated_book}'
    rotated_hist = linehistogram(rotated_img_path)
    
    best_match, angle_of_rotation = find_rotation_angle(rotated_hist, original_histograms)
    angle_of_rotation = np.degrees(angle_of_rotation)
    angle_of_rotation = 180 - angle_of_rotation
    if rotated_book==book_names[best_match]:
        number_of_matches +=1
    plt.figure()
    plt.subplot(121)
    rotated_img = cv.imread(f'part1/rotated_img_new/rotated_{rotated_book}', cv.IMREAD_COLOR)
    rotated_img = cv.cvtColor(rotated_img, cv.COLOR_BGR2RGB)
    plt.imshow(rotated_img)
    plt.title(f'Rotated Image: {rotated_book}')
    plt.xticks([]), plt.yticks([])

    plt.subplot(122)
    original_img = cv.imread(f"part1/img/{book_names[best_match]}", cv.IMREAD_COLOR)
    original_img = cv.cvtColor(original_img, cv.COLOR_BGR2RGB)
    plt.imshow(original_img)
    plt.title(f'Original Image: {book_names[best_match]}')
    plt.xticks([]), plt.yticks([])

original_histograms = []
for book_name in book_names:
    img_path = f'part1/img/{book_name}'
    hist = linehistogram(img_path)
    original_histograms.append(hist)
number_of_matches = 0
# Now, loop through each rotated book and find the match
for rotated_book in book_names:
    rotated_img_path = f'part1/rotated_img_new/rotated_{rotated_book}'
    rotated_hist = linehistogram(rotated_img_path)
    
    best_match, angle_of_rotation = find_rotation_angle(rotated_hist, original_histograms)
    angle_of_rotation = np.degrees(angle_of_rotation)
    angle_of_rotation = 180 - angle_of_rotation
    if rotated_book==book_names[best_match]:
        number_of_matches +=1
        
    print(f"Rotated book 'rotated_{rotated_book}' matches with original book '{book_names[best_match]}' with an angle of rotation of {angle_of_rotation:.2f} degrees.")
print("Number of matches: ", number_of_matches, 'when num_bins = 20\n')

original_histograms = []
for book_name in book_names:
    img_path = f'part1/img/{book_name}'
    hist = linehistogram(img_path, num_bins = 50)
    original_histograms.append(hist)
number_of_matches = 0
# Now, loop through each rotated book and find the match
for rotated_book in book_names:
    rotated_img_path = f'part1/rotated_img_new/rotated_{rotated_book}'
    rotated_hist = linehistogram(rotated_img_path, num_bins = 50)
    
    best_match, angle_of_rotation = find_rotation_angle(rotated_hist, original_histograms)
    angle_of_rotation = np.degrees(angle_of_rotation)
    angle_of_rotation = 180 - angle_of_rotation
    if rotated_book==book_names[best_match]:
        number_of_matches +=1
    print(f"Rotated book 'rotated_{rotated_book}' matches with original book '{book_names[best_match]}' with an angle of rotation of {angle_of_rotation:.2f} degrees.")
print("Number of matches: ", number_of_matches, 'when num_bins = 50\n')

original_histograms = []
for book_name in book_names:
    img_path = f'part1/img/{book_name}'
    hist = linehistogram(img_path, num_bins = 5)
    original_histograms.append(hist)
number_of_matches = 0
# Now, loop through each rotated book and find the match
for rotated_book in book_names:
    rotated_img_path = f'part1/rotated_img_new/rotated_{rotated_book}'
    rotated_hist = linehistogram(rotated_img_path, num_bins = 5)
    
    best_match, angle_of_rotation = find_rotation_angle(rotated_hist, original_histograms)
    angle_of_rotation = np.degrees(angle_of_rotation)
    angle_of_rotation = 180 - angle_of_rotation
    if rotated_book==book_names[best_match]:
        number_of_matches +=1
    print(f"Rotated book 'rotated_{rotated_book}' matches with original book '{book_names[best_match]}' with an angle of rotation of {angle_of_rotation:.2f} degrees.")
print("Number of matches: ", number_of_matches, 'when num_bins = 5\n')

plt.ioff()
plt.show()
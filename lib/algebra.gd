#! @Chapter Quiver algebras

#! We use the term **quiver algebra** for an algebra that is
#! either a path algebra or a quotient of a path algebra by
#! some ideal.

#! @Section Categories for algebras and algebra elements

#! @Description
#!  Category for elements of quiver algebras.
DeclareCategory( "IsQuiverAlgebraElement", IsRingElementWithOne and IsObjectWithDirection and IsMultiplicativeElementWithInverse );

#! @Description
#!  Category for quiver algebras.
DeclareCategory( "IsQuiverAlgebra", IsAlgebraWithOne and CategoryCollections( IsQuiverAlgebraElement ) and IsObjectWithDirection );

#!
DeclareCategory( "IsLeftQuiverAlgebra", IsQuiverAlgebra );

#!
DeclareCategory( "IsRightQuiverAlgebra", IsQuiverAlgebra );

#! @Description
#!  Category for ideals in quiver algebras.
DeclareCategory( "IsQuiverAlgebraIdeal",
                 IsRing and IsVectorSpace
                 and CategoryCollections( IsQuiverAlgebraElement )
                 and IsObjectWithSide );

#! @Description
#!  Category for two-sided ideals in quiver algebras.
DeclareCategory( "IsQuiverAlgebraTwoSidedIdeal", IsQuiverAlgebraIdeal );

#! @Description
#!  Category for (two-sided) ideals in path algebras.
DeclareCategory( "IsPathAlgebraIdeal", IsQuiverAlgebraTwoSidedIdeal );

#! @Description
#!  Category for elements of path algebras.
DeclareCategory( "IsPathAlgebraElement", IsQuiverAlgebraElement );

#! @Description
#!  Category for path algebras.
DeclareCategory( "IsPathAlgebra", IsQuiverAlgebra );

#! @Description
#!  Category for elements of quotients of path algebras.
DeclareCategory( "IsQuotientOfPathAlgebraElement", IsQuiverAlgebraElement );

#! @Description
#!  Category for quotients of path algebras.
DeclareCategory( "IsQuotientOfPathAlgebra", IsQuiverAlgebra );


#! @Section Constructing algebras

#! @Arguments k, Q
#! @Description
#!  Constructs the path algebra over the field <A>k</A>
#!  using the quiver <A>Q</A>.
DeclareOperation( "PathAlgebra", [ IsField, IsQuiver ] );

#! @InsertChunk Example_PathAlgebra

#! @BeginGroup QuotientOfPathAlgebra
#! @Description
#!  Constructs a quotient of a path algebra.
#!  <P/>
#!  The first argument is a path algebra <A>kQ</A>.
#!  The second argument is either an ideal <A>I</A> in the algebra <A>kQ</A>
#!  or a list <A>relations</A> of elements of <A>kQ</A>.
#!  The result is <A>kQ</A> divided by the ideal <A>I</A>,
#!  or by the ideal generated by <A>relations</A>.
#!  <P/>
#!  The <C>/</C> operator is defined to do the same as <C>QuotientOfPathAlgebra</C>,
#!  so <C>QuotientOfPathAlgebra( <A>kQ</A>, <A>I</A> )</C> or
#!  <C>QuotientOfPathAlgebra( <A>kQ</A>, <A>relations</A> )</C>
#!  can also be written as
#!  <C><A>kQ</A>/<A>I</A></C> or
#!  <C><A>kQ</A>/<A>relations</A></C>.
#! @Arguments kQ, I
DeclareOperation( "QuotientOfPathAlgebra", [ IsPathAlgebra, IsPathAlgebraIdeal ] );
#! @Arguments kQ, relations
DeclareOperation( "QuotientOfPathAlgebra", [ IsPathAlgebra, IsDenseList ] );
#! @EndGroup

#! @BeginGroup QuotientOfQuiverAlgebra
#! @Description
#!  Factor out an ideal of a quiver algebra.
#! @Returns <Ref Filt="IsQuiverAlgebra"/>
#! @Arguments A, I
DeclareOperation( "\/", [ IsQuiverAlgebra, IsQuiverAlgebraTwoSidedIdeal ] );
#! @Arguments A, relations
DeclareOperation( "\/", [ IsQuiverAlgebra, IsDenseList ] );
#! @EndGroup

#! @InsertChunk Example_QuotientOfPathAlgebra


#! @Arguments K
#! @Returns <Ref Filt="IsQuiverAlgebra"/>
#! @Description
#!  Returns the one-dimensional (left or right) quiver algebra over the field <A>K</A>. 
#!  First argument is a direction argument, either LEFT or RIGHT.
DeclareOperation( "FieldAsQuiverAlgebra", [ IsDirection, IsField ] );  

#! @Arguments K
#! @Returns <Ref Filt="IsQuiverAlgebra"/>
#! @Description
#!  Returns the one-dimensional (left) quiver algebra over the field <A>K</A>. 
DeclareAttribute( "FieldAsLeftQuiverAlgebra", IsField );  

#! @Arguments K
#! @Returns <Ref Filt="IsQuiverAlgebra"/>
#! @Description
#!  Returns the one-dimensional (right) quiver algebra over the field <A>K</A>. 
DeclareAttribute( "FieldAsRightQuiverAlgebra", IsField );  


#! @Section Information about an algebra

#! @Arguments A
#! @Returns <Ref Filt="IsQuiver"/>
#! @Description
#!  Returns the quiver Q of the quiver algebra <A>A</A> = $kQ/I$.
DeclareAttribute( "QuiverOfAlgebra", IsQuiverAlgebra );

#! @Arguments A
#! @Returns list of <Ref Filt="IsPathAlgebraElement"/>
#! @Description
#!  Returns a list of relations for the quiver algebra <A>A</A>.
#!  That is, if <A>A</A> = $kQ/I$, then this operation returns a list
#!  of generators for the ideal $I$.
#!  If <A>A</A> is a path algebra, this operation returns the empty list.
DeclareAttribute( "RelationsOfAlgebra", IsQuiverAlgebra );

#! @Arguments A
#! @Returns <Ref Filt="IsPathAlgebraIdeal"/>
#! @Description
#!  For a quotient <A>A</A> = $kQ/I$ of a path algebra,
#!  this operation returns the ideal $I$.
DeclareAttribute( "IdealOfQuotient", IsQuiverAlgebra );

# field of a QuiverAlgebra: LeftActingDomain
#! <ManSection>
#! <Attr Name="LeftActingDomain" Arg="A"/>
#! <Description>
#! Returns the underlying field of the algebra <A>A</A>.
#! </Description>
#! <Returns><C>IsField</C></Returns>
#! </ManSection>

#! @Arguments A
#! @Returns <Ref Filt="IsPathAlgebra"/>
#! @Description
#!  Given a quiver algebra <A>A</A> = $kQ/I$, this operation returns
#!  the path algebra $kQ$.
DeclareAttribute( "PathAlgebra", IsQuiverAlgebra );

#! @Description
#!  The orientation of the quiver of the algebra <A>A</A>.
#! @Arguments A
#! @Returns <C>"left"</C> or <C>"right"</C>
#DeclareAttribute( "Orientation", IsQuiverAlgebra );

#! @Description
#!  Checks whether the quiver algebra <A>A</A> is finite-dimensional.
#! @Arguments A
#DeclareProperty( "IsFiniteDimensional", IsQuiverAlgebra );

#! @Description
#!  Check whether <A>A</A> is a quotient of a path algebra by an admissible ideal.
#! @Arguments A
DeclareProperty( "IsAdmissibleQuiverAlgebra", IsQuiverAlgebra );

#! @Description
#!  Returns the Loewy length of the algebra <A>A</A>.
#! @Arguments A
#! @Returns <C>IS_INT</C>
#DeclareAttribute( "LoewyLength", IsQuiverAlgebra );

#! @Section Basis

#! @Description
#!  GAP category for bases of quiver algebras.
#! @Label
DeclareCategory( "IsQuiverAlgebraBasis", IsBasis );

#! @Description
#!  A basis for the quiver algebra <A>A</A>.
#! @Arguments A
#! @Returns <Ref Filt="IsQuiverAlgebraBasis"/>
#DeclareAttribute( "CanonicalBasis", IsQuiverAlgebra );

#! @Description
#!  The elements of a quiver algebra basis <A>B</A>.
#! @Arguments B
#! @Returns list of algebra elements
#DeclareAttribute( "BasisVectors", IsQuiverAlgebraBasis );

#! @Description
#!  The elements of a quiver algebra basis <A>B</A>, given as paths in the quiver.
#! @Arguments B
#! @Returns list of paths
DeclareAttribute( "BasisPaths", IsQuiverAlgebraBasis );

#! @Description
#!  Returns a list of paths forming a basis for the set of uniform elements
#!  in the quiver algebra <A>A</A> with
#!  <A>v1</A> as source and <A>v2</A> as target.
#! @Arguments A, v1, v2
DeclareOperation( "BasisPathsBetweenVertices", [ IsQuiverAlgebra, IsQuiverVertex, IsQuiverVertex ] );


#! @Section Accessing algebra elements

#! @BeginGroup QuiverAlgebraElement
#! @Returns <Ref Filt="IsQuiverAlgebraElement"/>
#! @Description
#!  Creates an element of a quiver algebra.
#!  <P/>
#!  The argument <A>A</A> is a quiver algebra,
#!  <A>paths</A> is a list of paths in the quiver of <A>A</A>,
#!  and <A>coefficients</A> a list of coefficients.
#!  The lists <A>paths</A> and <A>coefficients</A> must have the same length.
#!  If the paths are $p_1, \ldots, p_n$
#!  and the coefficients are $c_1, \ldots, c_n$,
#!  then the result is the linear combination
#!  $\sum_{i=1}^n c_i p_i$.
#!  <P/>
#!  For the operation <C>QuiverAlgebraElement</C>,
#!  the elements in <A>paths</A> may be listed in any order,
#!  and the same paths can occur several times in the list.
#!  The operation <C>QuiverAlgebraElementNC</C> assumes that
#!  the list of paths is sorted in decreasing order
#!  (by the path ordering of the quiver)
#!  and does not have any duplicates.
#! @Arguments A, coefficients, paths
DeclareOperation( "QuiverAlgebraElement", [ IsQuiverAlgebra, IsHomogeneousList, IsHomogeneousList ] );
#! @Arguments A, coefficients, paths
DeclareOperation( "QuiverAlgebraElementNC", [ IsQuiverAlgebra, IsHomogeneousList, IsHomogeneousList ] );
#! @EndGroup

#! @InsertChunk Example_QuiverAlgebraElement

#! @Arguments A, e
#! @Description
#!  Given a quotient <A>A</A> = kQ/I of a path algebra kQ,
#!  and an element <A>e</A> of kQ, this operation produces
#!  the element of <A>A</A> represented by <A>e</A>.
DeclareGlobalFunction( "QuotientOfPathAlgebraElement" );

#! @InsertChunk Example_QuotientOfPathAlgebraElement

#! @Arguments A, p
#! @Description
#!  Returns the path <A>p</A> as an element of the quiver algebra <A>A</A>.
DeclareOperation( "PathAsAlgebraElement", [ IsQuiverAlgebra, IsPath ] );

#! @InsertChunk Example_PathAsAlgebraElement

#!
DeclareOperation( "Vertices", [ IsQuiverAlgebra ] );
DeclareAttribute( "VerticesAttr", IsQuiverAlgebra );


#!
DeclareAttribute( "Arrows", IsQuiverAlgebra );

#!
DeclareAttribute( "PrimitivePaths", IsQuiverAlgebra );

#! @BeginGroup AlgebraElementByLabel
#! @Description
#!  Returns the primitive path (vertex or arrow) with label <A>label</A>,
#!  as an element of the quiver algebra <A>A</A>.
#!  If no such path exists, an error is signalled.
#!  The operation <C><A>A</A>[ <A>label</A> ]</C> is equivalent to
#!  <C>AlgebraElementByLabel( <A>A</A>, <A>label</A> )</C>.
#! @Returns <Ref Filt="IsQuiverAlgebraElement"/>
#! @Arguments A, label
DeclareOperation( "AlgebraElementByLabel", [ IsQuiverAlgebra, IsObject ] );
#! @Arguments A, label
DeclareOperation( "\[\]", [ IsQuiverAlgebra, IsObject ] );
#! @EndGroup

#! @InsertChunk Example_AlgebraElementByLabel

#! @Arguments A, string
#! @Description
#!  Returns the path described by the string <A>string</A>
#!  (see <Ref Oper="PathFromString"  Label="for IsQuiver, IsString"/>)
#!  as an element of the quiver algebra <A>A</A>.
#!  If no such path exists, an error is signalled.
#!  <P/>
#!  This operation can also be called by writing <C><A>A</A>.str</C>,
#!  where <C>str</C> is an unquoted string literal.
#! @Returns <Ref Filt="IsQuiverAlgebraElement"/>
DeclareOperation( "AlgebraElementFromString", [ IsQuiverAlgebra, IsString ] );

#! @InsertChunk Example_AlgebraElementFromString


#! @Section Information about an element

#! @Arguments e
#! @Returns <Ref Filt="IsQuiverAlgebra"/>
#! @Description
#!  Returns the quiver algebra the element <A>e</A> belongs to.
#! @Label
DeclareAttribute( "AlgebraOfElement", IsQuiverAlgebraElement );

#! @Arguments e
#! @Returns list of <Ref Filt="IsPath"/>
#! @Description
#!  Returns a list of paths for the algebra element <A>e</A>.
#!  <P/>
#!  Every element of a quiver algebra can be written as a linear combination
#!  $\sum_{i=1}^n c_i p_i$ of paths.
#!  This operation produces the list
#!  $p_1, \ldots, p_n$ of paths for the element <A>e</A>.
#!  The corresponding coefficients
#!  $c_1, \ldots, c_n$ can be obtained by the operation
#!  <Ref Oper="Coefficients"/>.
#!  <P/>
#!  The paths are ordered in decreasing order,
#!  by the path ordering of the quiver.
#!  <P/>
#!  If <A>e</A> is an element of a path algebra, then there is a unique
#!  way to express it as a linear combination of paths.
#!  If <A>e</A> is an element of a quotient of a path algebra, then there
#!  may be several ways to express it as a linear combination of paths.
#!  In this case, the chosen combination is that of
#!  <C>Representative( <A>e</A> )</C>
#!  (see <Ref Attr="Representative" Label="for IsQuotientOfPathAlgebraElement"/>).
#! @Label
DeclareAttribute( "Paths", IsQuiverAlgebraElement );

#! @Arguments e
#! @Returns list of field elements
#! @Description
#!  Returns a list of coefficients for the algebra element <A>e</A>.
#!  <P/>
#!  Every element of a quiver algebra can be written as a linear combination
#!  $\sum_{i=1}^n c_i p_i$ of paths.
#!  The attribute <Ref Attr="Paths"/> gives the list
#!  $p_1, \ldots, p_n$ of paths for the element <A>e</A>,
#!  and this operation returns the corresponding list
#!  $c_1, \ldots, c_n$ of coefficients.
#! @Label
DeclareOperation( "Coefficients", [ IsQuiverAlgebraElement ] );

# Would like to have Coefficients as attribute,
# but it is declared as operation elsewhere.
# Therefore use extra attribute CoefficientsAttr to be able
# to store the coefficients.
DeclareAttribute( "CoefficientsAttr", IsQuiverAlgebraElement );

#! @Description
#!  Coefficients of some specific paths.
#!
#!  Given a list <A>paths</A> of paths and an algebra element <A>e</A>,
#!  this operation returns the coefficients of those paths in the
#!  expression of <A>e</A> as a linear combination of paths.
#! @Arguments paths, e
#! @Returns list of field elements
#! @Label
DeclareOperation( "CoefficientsOfPaths", [ IsList, IsQuiverAlgebraElement ] );

#! @Description
#!  Coefficients of some specific paths, given in increasing order.
#!
#!  This operation does the same as <Ref Oper="CoefficientsOfPaths"/>,
#!  but assumes that the paths are given in increasing order.
#! @Arguments paths, e
#! @Returns list of field elements
#! @Label
DeclareOperation( "CoefficientsOfPathsSorted", [ IsList, IsQuiverAlgebraElement ] );

#! @Arguments e
#! @Description
#!  The operation uses the attribute <C>LabelAsLaTeXString</C> of primitive paths to compute
#!  a LaTeX string for the algebra element <A>e</A>. One can pass optional values for <A>MultiplicationSymbol</A>
#!  to specify the multiplication-symbol between the arrows of the paths, and <A>ScalarMultiplicationSymbol</A>
#!  to specify the multiplication-symbol between scalars and paths.
#! @Returns <C>IsString</C>
DeclareOperation( "LaTeXStringForQPA", [ IsQuiverAlgebraElement ] );

#! @InsertChunk Example_LaTeX_RightQuiver

#! @Subsection Example

#! Here is an example demonstrating use of the above functions:

#! @BeginExampleSession
#! gap> Q := LeftQuiver( "Q(3)[a:1->2,b:2->3,c:2->3]" );
#! Q(3)[a:1->2,b:2->3,c:2->3]
#! gap> kQ := PathAlgebra( Rationals, Q );
#! Rationals * Q
#! gap> e := 7 * kQ[2] + 5 * kQ.ca + 9 * kQ.ba;
#! 5*(c*a) + 9*(b*a) + 7*(2)
#! gap> AlgebraOfElement( e ) = kQ;
#! true
#! gap> Paths( e );
#! [ (c*a), (b*a), (2) ]
#! gap> Coefficients( e );
#! [ 5, 9, 7 ]
#! gap> CoefficientsOfPaths( [ Q[1], Q[2], Q[3], Q.ba ], e );
#! [ 0, 7, 0, 9 ]
#! gap> A := kQ / [ kQ.ba - kQ.ca ];
#! (Rationals * Q) / [ -1*(c*a) + 1*(b*a) ]
#! gap> f := 7 * A[2] + 5 * A.ba + 9 * A.ca;
#! { 14*(b*a) + 7*(2) }
#! gap> AlgebraOfElement( f ) = A;
#! true
#! gap> CoefficientsOfPaths( [ Q.ca, Q.ba ], f );
#! [ 0, 14 ]
#! @EndExampleSession

#! For a quotient of a path algebra, the functions
#! <Ref Oper="Paths"/>,
#! <Ref Oper="Coefficients"/>,
#! <Ref Oper="CoefficientsOfPaths"/> and
#! <Ref Oper="CoefficientsOfPathsSorted"/>
#! all act on the canonical representative of the given element.
#! Thus, even though we used the path
#! <M>ca</M> in the expression for the element <C>f</C>,
#! the coefficient of that path was zero since it disappeared
#! in the canonical representative.

#! @EndSubsection

#! @Arguments e
#! @Returns <C>true</C> or <C>false</C>
#! @Description
#!  Checks whether the element <A>e</A> is uniform,
#!  that is, whether all paths in the element have the same
#!  source and the same target.
DeclareProperty( "IsUniform", IsQuiverAlgebraElement );

#! @Arguments e
#! @Returns <C>true</C> or <C>false</C>
#! @Description
#!  Checks whether the element <A>e</A> is left uniform.
DeclareProperty( "IsLeftUniform", IsQuiverAlgebraElement );

#! @Arguments e
#! @Returns <C>true</C> or <C>false</C>
#! @Description
#!  Checks whether the element <A>e</A> is right uniform.
DeclareProperty( "IsRightUniform", IsQuiverAlgebraElement );

#! @Arguments e
#! @Returns <Ref Filt="IsPathAlgebraElement"/>
#! @Description
#!  Returns the canonical representative path algebra element
#!  of the element <A>e</A> of a quotient of a path algebra.
DeclareAttribute( "Representative", IsQuotientOfPathAlgebraElement );


#! @Section Acting on elements

#! @Arguments a1, a2
#! @Returns <Ref Filt="IsQuiverAlgebraElement"/>
#! @Description
#!  Multiply algebra elements <A>a1</A> and <A>a2</A>.
# DeclareOperation( "\*", [ IsQuiverAlgebraElement, IsQuiverAlgebraElement ] );

#! @Description
#!  Compose the algebra elements <A>e1</A> and <A>e2</A>.
#!
#!  This is the same as multiplication of elements, except that the paths
#!  are combined in source-to-target order as by <Ref Func="ComposePaths"/>.
#!  This means that for an algebra over a right quiver,
#!  <C>ComposeElements( e1, e2 )</C> is the same as <C>e1 * e2</C>,
#!  while for an algebra over a left quiver,
#!  <C>ComposeElements( e1, e2 )</C> is the same as <C>e2 * e1</C>.
#! @Returns <Ref Filt="IsQuiverAlgebraElement"/>
#! @Arguments e1, e2
DeclareOperation( "ComposeElements", [ IsQuiverAlgebraElement, IsQuiverAlgebraElement ] );

#! @Arguments a, p
#! @Returns <Ref Filt="IsQuiverAlgebraElement"/>
#! @Description
#!  Act on the algebra element <A>a</A> with the path <A>p</A>.
DeclareOperation( "PathAction", [ IsQuiverAlgebraElement, IsPath ] );


#! @Section Manipulation of elements

#! @Arguments e, A, f
#! @Returns <Ref Filt="IsQuiverAlgebraElement"/>
#! @Description
#!  Translate the element <A>e</A> to an element in the
#!  quiver algebra <A>A</A> by using the function <A>f</A>
#!  on each path.
DeclareOperation( "TranslateAlgebraElement", [ IsQuiverAlgebraElement, IsQuiverAlgebra, IsFunction ] );


#! @Section Operations related to Groebner basis theory

#! @Arguments e
#! @Returns <Ref Filt="IsPath"/>
#! @Description
#!  Returns the leading path of the path algebra element <A>e</A>,
#!  that is, the path occuring in <A>e</A> which is largest with
#!  respect to the quiver's ordering of paths.
DeclareAttribute( "LeadingPath", IsPathAlgebraElement );

#! @Arguments e
#! @Returns field element
#! @Description
#!  Returns the leading coefficient of the path algebra element <A>e</A>,
#!  that is, the coefficient of the leading path.
DeclareOperation( "LeadingCoefficient", [ IsPathAlgebraElement ] );

#! @Arguments e
#! @Returns <Ref Filt="IsPathAlgebraElement"/>
#! @Description
#!  Returns the leading term of the path algebra element <A>e</A>.
DeclareAttribute( "LeadingTerm", IsPathAlgebraElement );

#! @Arguments e
#! @Returns <Ref Filt="IsPathAlgebraElement"/>
#! @Description
#!  Returns the sum of all the non-leading terms of the path algebra element <A>e</A>.
DeclareAttribute( "NonLeadingTerms", IsPathAlgebraElement );

#! @Arguments e, divisors
#! @Returns list
#! @Description
#!  Performs division of the path algebra element <A>e</A>
#!  by the elements in the list <A>divisors</A>.
#!  <P/>
#!  When dividing an element $e$ by a list $d_1, \ldots, d_n$ of divisors,
#!  the goal is to find a remainder $r$ and left/right quotients
#!  $L_{i,j}$ and $R_{i,j}$
#!  (for $1 \le i \le n$ and $1 \le j \le m_i$, where
#!  $m_i$ is some integer depending on $i$) such that
#!  $$ e = r + \sum_{i=1}^n \sum_{j=1}^{m_i} L_{i,j} \cdot d_i \cdot R_{i,j}. $$
#!  <P/>
#!  This operation returns a list <C>[ quotients, remainder ]</C>,
#!  where <C>quotients</C> is a list containing the left/right quotients,
#!  and <C>remainder</C> is the remainder.
#!  The left quotient $L_{i,j}$ is accessible as <C>quotients[ i ][ j ][ 1 ]</C>,
#!  and the right quotient $R_{i,j}$ as <C>quotients[ i ][ j ][ 2 ]</C>.
DeclareOperation( "DivideByList", [ IsPathAlgebraElement, IsList ] );

#! @Arguments e, divisors
#! @Returns <Ref Filt="IsPathAlgebraElement"/>
#! @Description
#!  Reduce the path algebra element <A>e</A> by the elements
#!  in the list <A>divisors</A>.
#!  <P/>
#!  This operation returns the remainder produced by
#!  <Ref Oper="DivideByList" Label="for IsPathAlgebraElement, IsList"/>.
DeclareOperation( "Reduce", [ IsPathAlgebraElement, IsList ] );

#! @Arguments f, g, b, c
#! @Returns <Ref Filt="IsPathAlgebraElement"/>
#! @Description
#!  Computes an overlap relation.
#!  Given two path algebra elements <A>f</A> and <A>g</A>,
#!  and two paths <A>b</A> and <A>c</A>, such that
#!  <C>LeadingPath( f ) * c = b * LeadingPath( g )</C>,
#!  this operation produces the overlap relation
#!  $$ \frac{1}{LC(f)} fc - \frac{1}{LC(g)} bg $$
#!  <A>f</A> and <A>g</A> with respect to <A>b</A> and <A>c</A>.
DeclareOperation( "OverlapRelation",
                  [ IsPathAlgebraElement, IsPathAlgebraElement,
                    IsPath, IsPath ] );

#! @Arguments f, g
#! @Returns <Ref Filt="IsPathAlgebraElement"/>
#! @Description
#!  Finds all overlap relations between the path algebra elements
#!  <A>f</A> and <A>g</A>.
#!  <P/>
#!  We consider two elements $f$ and $g$ to have an overlap
#!  when there are paths $b$ and $c$ such that
#!  $LP(f) \cdot c = b \cdot LP(g)$.
#!  The corresponding overlap relation is then the element
#!  $$ \frac{1}{LC(f)} fc - \frac{1}{LC(g)} bg. $$
#!  For a given pair $(f,g)$, there may be several such overlap
#!  relations, corresponding to several choices of paths $(b,c)$.
#!  This operation constructs all these overlap relations,
#!  and returns them as a list.
#!  <P/>
#!  Overlap relations are interesting because they point to obstructions
#!  to a list $G$ of generators of an ideal forming a Groebner basis:
#!  if some overlap relation between two elements of $G$ reduces to
#!  a nonzero remainder $r$ when divided by $G$, then $G$ is not a Groebner basis.
#!  In Buchberger's algorithm, we then add the remainder $r$ to the
#!  list $G$.
#!  <P/>
#!  Note that our definition of overlaps does not include situations of the form
#!  $LP(f) = a \cdot LP(g) \cdot a'$,
#!  although they too give obstructions to a set being a Groebner basis,
#!  and would be considered as overlaps by some authors.
DeclareOperation( "OverlapRelations",
                  [ IsPathAlgebraElement, IsPathAlgebraElement ] );

#! @Arguments G
#! @Returns list of <Ref Filt="IsPathAlgebraElement"/>
#! @Description
#!  Returns a tip reduced version of the list <A>G</A>
#!  of path algebra elements.
#!  The original list is not modified.
#!  <P/>
#!  The resulting list has the following properties:
#!  (1) It generates the same ideal as <A>G</A> does.
#!  (2) No element in the list has a leading path which divides
#!  the leading path of another element in the list.
DeclareOperation( "TipReduce", [ IsHomogeneousList ] );

#! @Arguments G
#! @Returns list of <Ref Filt="IsPathAlgebraElement"/>
#! @Description
#!  Given a list <A>G</A> of generators for an ideal $I$ in a path algebra,
#!  this operation produces a Groebner basis for the ideal $I$.
DeclareOperation( "ComputeGroebnerBasis", [ IsHomogeneousList ] );

#! @Section Algebra constructions

#! @Arguments A
#! @Returns <Ref Filt="IsQuiverAlgebra"/>
#! @Description
#!  Returns the opposite algebra of <A>A</A>.
DeclareAttribute( "OppositeAlgebra", IsQuiverAlgebra );

#! @Arguments e
#! @Returns <Ref Filt="IsQuiverAlgebraElement"/>
#! @Description
#!  Returns the element corresponding to <A>e</A> in the opposite algebra.
DeclareAttribute( "OppositeAlgebraElement", IsQuiverAlgebraElement );

#! @Description
#!  Returns either the algebra <A>A</A> itself or its opposite.
#!  If <A>A</A> is left-oriented, then <C>A^LEFT</C> is <A>A</A>
#!  and <C>A^RIGHT</C> is the opposite algebra of <A>A</A>.
#!  If <A>A</A> is right-oriented, then <C>A^RIGHT</C> is <A>A</A>
#!  and <C>A^LEFT</C> is the opposite algebra of <A>A</A>.
#! @Arguments A, side
#! @Returns <Ref Filt="IsQuiverAlgebra"/>
#DeclareOperation( "\^", [ IsQuiverAlgebra, IsString ] );

DeclareOperation( "\^", [ IsQuiverAlgebra, IsSide ] );
DeclareOperation( "\^", [ IsDenseList, IsSide ] );

#! @Arguments A, B
#! @Returns <Ref Filt="IsQuiverAlgebra"/>
#! @Description
#!  Returns the tensor product of the quiver algebras <A>A</A> and <A>B</A>.
DeclareOperation( "TensorProductOfAlgebras", [ IsQuiverAlgebra, IsQuiverAlgebra ] );

#! @Arguments As
#! @Returns <Ref Filt="IsQuiverAlgebra"/>
#! @Description
#!  Returns the tensor product of the quiver algebras in the list <A>As</A>.
DeclareOperation( "TensorProductOfAlgebras", [ IsDenseList ] );

#! @Arguments T, A, B
#! @Returns <C>true</C> or <C>false</C>
#! @Description
#!  Returns <C>true</C> if the algebra <A>T</A> is a tensor product of
#!  algebras; <C>false</C> otherwise.
DeclareProperty( "IsTensorProductOfAlgebras", IsQuiverAlgebra );

DeclareAttribute( "TensorProductFactors", IsQuiverAlgebra );

DeclareAttribute( "TensorProductFactorsLeftRight", IsQuiverAlgebra );

#! @Description
#!  Given an iterated tensor product of algebras, returns the isomorphism to the
#!  corresponding flat tensor product.
#! @Arguments T
#! @Returns <Ref Filt="IsQuiverAlgebraHomomorphism"/>
DeclareAttribute( "IsomorphismToFlatTensorProduct", IsTensorProductOfAlgebras );

#! @Description
#!  Given an iterated tensor product of algebras, returns the isomorphism from the
#!  corresponding flat tensor product.
#! @Arguments T
#! @Returns <Ref Filt="IsQuiverAlgebraHomomorphism"/>
DeclareAttribute( "IsomorphismFromFlatTensorProduct", IsTensorProductOfAlgebras );

#! @Arguments a, b, T
#! @Returns <Ref Filt="IsQuiverAlgebraElement"/>
#! @Description
#!  Returns <M>a\otimes b</M> as an element of the the tensor algebra <A>T</A>.  The algebra <A>T</A>
#!  must be the tensor product of the algebra containing <A>a</A> and the algebra 
#!  containing <A>b</A>. 
DeclareOperation( "ElementaryTensor", [ IsQuiverAlgebraElement, IsQuiverAlgebraElement, IsQuiverAlgebra ] );

#! @Arguments T
#! @Returns list of <Ref Filt="IsQuiverAlgebraHomomorphism"/>
#!  Returns two quiver algebra monomorhisms <M>A\to A\otimes_k B</M>
#! and <M>B\to A\otimes_k B</M> given the tensor product <Arg>T</Arg>
#! equal to <M>A\otimes_k B</M> for two <M>k</M>-algebra <M>A</M> and
#! <M>B</M> and a field <M>k</M>.
DeclareAttribute( "TensorAlgebraInclusions", IsTensorProductOfAlgebras ); 

#! @Arguments T
#! @Returns <Ref Filt="IsQuiverAlgebraHomomorphism"/>
#! @Description 
#!  Returns the algebra isomorphism from <M>k\otimes_k B \to B</M>,
#!  given the tensor product <Arg>T</Arg> equal to <M>k\otimes_k B</M>
#!  as input, for a field <M>k</M>.  
DeclareOperation( "TensorAlgebraLeftIdentification", [ IsTensorProductOfAlgebras ] );  

#! @Arguments T
#! @Returns <Ref Filt="IsQuiverAlgebraHomomorphism"/>
#! @Description 
#!  Returns the algebra isomorphism from <M>A\otimes_k k \to A</M>,
#!  given the tensor product <Arg>T</Arg> equal to <M>A\otimes_k k</M>
#!  as input, for a field <M>k</M>.  
DeclareOperation( "TensorAlgebraRightIdentification", [ IsTensorProductOfAlgebras ] );  

#! @Arguments A
#! @Returns <Ref Filt="IsQuiverAlgebra"/>
#! @Description
#!  Returns the enveloping algebra of <A>A</A>.
DeclareAttribute( "EnvelopingAlgebra", IsQuiverAlgebra );

#! @Description
#!  Given an algebra <A>T</A>
#!  which is the tensor product $A \otimes_k B$ of two algebras,
#!  returns the canonical isomorphism from <A>T</A> to
#!  the tensor product $B \otimes_k A$
#!  of the same algebras in the opposite order.
#! @Arguments T
DeclareAttribute( "FlipTensorAlgebra", IsTensorProductOfAlgebras );

#! @Section Algebra homomorphisms 

#! @Description
#!  Category for algebra homomorphisms between quiver algebras.
DeclareCategory( "IsQuiverAlgebraHomomorphism", IsAlgebraWithOneHomomorphism );

#! @Arguments A, B, verteximages, arrowimages
#! @Returns <Ref Filt="IsQuiverAlgebraHomomorphism"/>
#! @Description
#!  Returns the algebra homomorphism from the quiver algebra <A>A</A> to the quiver
#!  algebra <A>B</A> that maps vertices in <A>A</A> to <A>verteximages</A> and the 
#!  arrows in <A>A</A> to <A>arrowimages</A>.  It signals an error if the arguments
#!  do not give a well-defined homomorphism of algebras. 
DeclareOperation( "QuiverAlgebraHomomorphism", [ IsQuiverAlgebra, IsAlgebraWithOne, IsHomogeneousList, IsHomogeneousList ] );

#! @Arguments A, B, genimages
#! @Returns <Ref Filt="IsQuiverAlgebraHomomorphism"/>
#! @Description
#!  Returns the algebra homomorphism from the quiver algebra <A>A</A> to the quiver
#!  algebra <A>B</A> that maps the generators (vertices and arrows) in <A>A</A> to <A>genimages</A>. 
#!  It is assumed that <A>genimages</A> is a list, where the first elements are the images of the vertices 
#!  and the next elements are the images of the arrows, as elements in the algebra <A>B</A>.  
#!  It signals an error if the arguments do not give a well-defined homomorphism of algebras. 
DeclareOperation( "QuiverAlgebraHomomorphism", [ IsQuiverAlgebra, IsAlgebraWithOne, IsHomogeneousList ] );

#! @Arguments A, B, f
#! @Returns <Ref Filt="IsQuiverAlgebraHomomorphism"/>
#! @Description
#!  Returns the algebra homomorphism from the quiver algebra <A>A</A> to the quiver
#!  algebra <A>B</A> given by the function <A>f</A>.
#!
#!  The function <A>f</A> should take an element of <A>A</A> as argument
#!  and return an element of <A>B</A>.
DeclareOperation( "QuiverAlgebraHomomorphism", [ IsQuiverAlgebra, IsAlgebraWithOne, IsFunction ] );

#! @Description
#!  Construct a quiver algebra homomorphism from a quiver homomorphism.
#! @Arguments A, B, f
#! @Returns IsQuiverAlgebraHomomorphism
DeclareOperation( "QuiverAlgebraHomomorphism", [ IsQuiverAlgebra, IsQuiverAlgebra, IsQuiverHomomorphism ] );

#! @Arguments f
#! @Returns a list of algebra elements
#! @Description
#!  Returns a list of algebra elements in <C>B</C> that the vertices in the quiver algebra <C>A</C> are mapped to
#!  with the algebra homomorphism <A>f</A> defined from <C>A</C> to <C>B</C>. 
DeclareAttribute( "VertexImages", IsQuiverAlgebraHomomorphism );

#! @Arguments f
#! @Returns a list of algebra elements
#! @Description
#!  Returns a list of algebra elements in <C>B</C> that the arrows in the quiver algebra <C>A</C> are mapped to
#!  with the algebra homomorphism <A>f</A> defined from <C>A</C> to <C>B</C>. 
DeclareAttribute( "ArrowImages", IsQuiverAlgebraHomomorphism );

#! @Description
#!  Creates the natural homomorphism from the algebra <A>A</A>
#!  to the quotient algebra <A>A</A>/<A>I</A>,
#!  where <A>I</A> is an ideal in <A>A</A>.
#! @Returns IsQuiverAlgebraHomomorphism
#! @Arguments A, I
# DeclareOperation( "NaturalHomomorphismByIdeal", [ IsQuiverAlgebra, IsQuiverAlgebraIdeal ] )

DeclareProperty( "IsNaturalHomomorphismByIdeal", IsQuiverAlgebraHomomorphism ); 

#! @Description
#!  Given a quiver algebra homomorphism <A>f</A>, say <M>f\colon R \to S</M>, 
#!  this function returns this homomorphism as a linear transformation from a 
#!  vectorspace <M>V_R</M> isomorphic to <M>R</M> and to a vectorspace <M>V_S</M> 
#!  isomorphic to <M>S</M>. Can go from <M>x</M> in <M>R</M> to <M>V_R</M> by  
#!  <C>Coefficients( Basis(R), x )</C>, and from <M>v</M> in <M>V_R</M> to 
#!  <M>R</M> by <C>LinearCombination( Basis(R), v )</C>.  Similar for <M>S</M>. 
#! @Returns <Ref Filt="IsLinearTransformation"/>
#! @Arguments f
# DeclareAttribute( "AsLinearTransformation", IsQuiverAlgebraHomomorphism );

#! @Description
#!  Given a quiver algebra homomorphism <A>f</A>, this function returns 
#!  the kernel of this homomorphism as an ideal in the source of <A>f</A>. 
#! @Returns <Ref Filt="IsQuiverAlgebraTwoSidedIdeal"/>
#! @Arguments f
# DeclareAttribute( "KernelObject", IsQuiverAlgebraHomomorphism );

#! @Section Properties of algebras

#! @Description
#!  Returns the Cartan matrix of the finite dimensional algebra <A>A</A>.
#! @Returns <C>IsMatrix</C>
#! @Arguments A
# DeclareAttribute( "CartanMatrix", IsQuiverAlgebra );

#! @Description
#!  Returns the centre of the finite dimensional algebra <A>A</A>.
#! @Returns <C>IsAlgebra</C>
#! @Arguments A
# DeclareAttribute( "Centre", IsQuiverAlgebra );

#! @Description
#!  Returns the Coxeter matrix of the finite dimensional algebra <A>A</A>.
#! @Returns <C>IsMatrix</C>
#! @Arguments A
DeclareAttribute( "CoxeterMatrix", IsQuiverAlgebra ); 

#! @Description
#!  Returns the Coxeter polynomial of the finite dimensional algebra <A>A</A>. 
#! @Returns <C>IsPolynomial</C>
#! @Arguments A
DeclareAttribute( "CoxeterPolynomial",  IsQuiverAlgebra  ); 

#! @Description
#!  This function returns true if the algebra  <A>A</A>  is finite 
#!  dimensional and distributive. Otherwise it returns false.
#! @Returns <C>true</C> or <C>false</C>
#! @Arguments A
DeclareProperty( "IsDistributiveAlgebra", IsQuiverAlgebra );

#! @Description
#!  This function returns true if the entered algebra  <A>A</A>  is a (finite
#!  dimensional) basic algebra and false otherwise. This method applies 
#!  to algebras over finite fields.
#! @Returns <C>true</C> or <C>false</C>
#! @Arguments A
DeclareProperty( "IsBasicAlgebra", IsAlgebraWithOne );

#! @Description
#!  This function returns true if the entered algebra  <A>A</A>  is a (finite
#!  dimensional) elementary algebra and false otherwise. This method 
#!  applies to algebras over finite fields. 
#! @Returns <C>true</C> or <C>false</C>
#! @Arguments A
DeclareProperty( "IsElementaryAlgebra", IsAlgebraWithOne );

#!
InstallTrueMethod( IsBasicAlgebra, IsElementaryAlgebra );

#! @Description
#!  This function finds the multiplicative identity of a finite 
#!  dimensional algebra <A>A</A>, if it exists.
#! @Returns algebra element
#! @Arguments A
DeclareOperation( "FindMultiplicativeIdentity", [ IsAlgebra ] );


#! @Section Units and inverses

#! @BeginGroup IsUnit
#! @Description
#!  Returns <C>true</C> or <C>false</C> according to whether the element <A>a</A> in 
#!  the algebra <A>A</A> is a multiplication unit or not.
#! @Returns <C>IsBool</C>
#! @Arguments a
# DeclareOperation( "IsUnit", [ IsQuiverAlgebraElement ] );
#! @Arguments A, a
# DeclareOperation( "IsUnit", [ IsQuiverAlgebra, IsQuiverAlgebraElement ] );
#! @EndGroup

#! @Description
#!  Returns the group of units in the algebra <A>A</A>, whenever <A>A</A> is an
#!  admissible quotient of a path algebra over a finite field. 
#! @Returns <C>IsGroup</C>
#! @Arguments A
# DeclareAttribute( "Units", IsQuiverAlgebra );

#! @Section Finite dimensional algebras as quiver algebras

#! @Description
#!  Returns the quiver of the entered algebra <Arg>A</Arg> whenever possible
#!  and a list of the images of the vertices and a list of the images of the
#!  arrows in this quiver in <Arg>A</Arg>.  The operation only applies when
#!  <Arg>A</Arg> is a finite dimensional indecomposable algebra over a finite 
#!  field, otherwise it returns an error message.  It checks if the algebra 
#!  <Arg>A</Arg> is basic and elementary over some field and otherwise it returns
#!  an error message.  In the list of images the images of the
#!  vertices are listed first and then the images of the arrows. 
#! @Returns <C>[ IsQuiverAlgebra, IsPahtAlgebraElements ]</C>
#! @Arguments A, direction
DeclareOperation( "FindQuiverOfAlgebra", [ IsAlgebraWithOne, IsDirection ] );

#! @Description
#!  Returns a (quotient of a) path algebra isomorphic to the entered
#!  algebra <Arg>A</Arg> whenever possible and a list of the images of
#!  the vertices and the arrows in this path algebra in <Arg>A</Arg>.  
#!  The operation only applies when <Arg>A</Arg> is a finite
#!  dimensional indecomposable algebra over a finite field, otherwise
#!  it returns an error message.  It checks if the algebra <Arg>A</Arg>
#!  is basic and elementary over some field and otherwise it returns
#!  an error message.  In the list of images the images of the
#!  vertices are listed first and then the images of the arrows. 
#! @Returns <C>[ IsQuiverAlgebra, IsPahtAlgebraElements ]</C>
#! @Arguments A, direction
DeclareOperation( "AlgebraAsQuiverAlgebra", [ IsAlgebraWithOne, IsDirection ] );


#

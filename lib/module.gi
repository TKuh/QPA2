DeclareRepresentation( "IsQuiverRepresentationElementRep", IsComponentObjectRep,
                       [ "representation", "vectors" ] );

InstallMethod( QuiverRepresentationElement, "for quiver representation and collection",
               [ IsQuiverRepresentation, IsDenseList ],
function( rep, vectors )
  local field, Q, numVertices, i, v;
  vectors := Immutable( vectors );
  field := FieldOfRepresentation( rep );
  Q := QuiverOfRepresentation( rep );
  numVertices := Length( Vertices( Q ) );
  if Length( vectors ) <> numVertices then
    Error( "Wrong number of vectors in QuiverRepresentationElement constructor ",
           "(", Length( vectors ), " given, expected ", numVertices, ")" );
  fi;
  for i in [ 1 .. numVertices ] do
    v := vectors[ i ];
    if not IsDenseList( v ) then
      Error( "Vector ", i, " in QuiverRepresentationElement constructor ",
             "is not a dense list: ", v );
    fi;
    if Length( v ) <> VertexDimension( rep, i ) then
      Error( "Vector ", i, " in QuiverRepresentationElement constructor ",
             "has wrong length (", Length( v ), ", should be ", VertexDimension( rep, i ), ")" );
    fi;
    if not ForAll( v, a -> a in field ) then
      Error( "Vector ", i, " in QuiverRepresentationElement constructor ",
             "contains elements which are not from the ground field" );
    fi;
  od;
  return QuiverRepresentationElementNC( rep, vectors );
end );

InstallMethod( QuiverRepresentationElementNC, "for quiver representation and collection",
               [ IsQuiverRepresentation, IsDenseList ],
function( rep, vectors )
  local elemType;
  elemType := NewType( ElementsFamily( FamilyObj( rep ) ),
                       IsQuiverRepresentationElement and IsQuiverRepresentationElementRep );
  return Objectify( elemType,
                    rec( representation := rep,
                         vectors := vectors ) );
end );

InstallMethod( QuiverRepresentationElementByVertices, "for quiver representation and dense lists",
               [ IsQuiverRepresentation, IsDenseList, IsDenseList ],
function( R, vertices, vectors )
  local field, zero, dims, repVectors, numVectors, i, vertex, vertexNumber, vector;
  field := FieldOfRepresentation( R );
  zero := Zero( field );
  dims := VertexDimensions( R );
  repVectors := List( dims,
                      d -> List( [ 1 .. d ], i -> zero ) );
  numVectors := Length( vectors );
  
  if Length( vertices ) <> numVectors then
    Error( "Different lengths of list of vertices (", Length( vertices ),
           ") and list of vectors (", numVectors, ")" );
  fi;
  for i in [ 1 .. numVectors ] do
    if not IsVertex( vertices[ i ] ) then
      Error( "Not a vertex: ", vertices[ i ] );
    fi;
    if not vertices[ i ] in QuiverOfRepresentation( R ) then
      Error( "Vertex ", vertices[ i ], " is not in the quiver of the representation ", R );
    fi;
    if ( not IsDenseList( vectors[ i ] ) ) or
       ( not ForAll( vectors[ i ], v -> v in field ) ) then
      Error( "Not a vector over the field ", field, ": ", vectors[ i ] );
    fi;
  od;
      
  for i in [ 1 .. numVectors ] do
    vertex := vertices[ i ];
    vertexNumber := VertexNumber( vertex );
    vector := vectors[ i ];
    if Length( vector ) <> dims[ vertexNumber ] then
      Error( "Wrong size of vector for vertex ", vertex,
             " (size is ", Length( vector ), ", should be ", dims[ vertexNumber ], ")" );
    fi;
    repVectors[ vertexNumber ] := vector;
  od;
  MakeImmutable( repVectors );
  return QuiverRepresentationElementNC( R, repVectors );
end );

InstallMethod( PrintObj, "for element of quiver representation",
               [ IsQuiverRepresentationElement ],
function( e )
  Print( "<quiver representation element ",
         ElementVectors( e ),
         ">" );
end );

InstallMethod( RepresentationOfElement, "for quiver representation element",
               [ IsQuiverRepresentationElement and IsQuiverRepresentationElementRep ],
function( e )
  return e!.representation;
end );

InstallMethod( ElementVectors, "for quiver representation element",
               [ IsQuiverRepresentationElement and IsQuiverRepresentationElementRep ],
function( e )
  return e!.vectors;
end );

InstallMethod( ElementVector, "for quiver representation element and positive integer",
               [ IsQuiverRepresentationElement, IsPosInt ],
function( e, i )
  return ElementVectors( e )[ i ];
end );

InstallMethod( ElementVector, "for quiver representation element and vertex",
               [ IsQuiverRepresentationElement, IsVertex ],
function( e, v )
  return ElementVectors( e )[ VertexNumber( v ) ];
end );

InstallMethod( PathAction,
               "for element of quiver representation and path",
               [ IsQuiverRepresentationElement, IsPath ],
function( e, p )
  local R, M, source_vec, target_vec;
  R := RepresentationOfElement( e );
  if VertexDimension( R, Target( p ) ) = 0 then
    return Zero( R );
  fi;
  M := MatrixForPath( R, p );
  source_vec := ElementVector( e, Source( p ) );
  if IsLeftPath( p ) then
    target_vec := M * source_vec;
  else
    target_vec := source_vec * M;
  fi;
  return QuiverRepresentationElementByVertices( R, [ Target( p ) ], [ target_vec ] );
end );

InstallMethod( QuiverAlgebraAction,
               "for element of quiver representation and element of quiver algebra",
               [ IsQuiverRepresentationElement, IsQuiverAlgebraElement ],
function( re, ae )
  local Cs, Ps;
  Cs := Coefficients( ae );
  Ps := Paths( ae );
  return Sum( ListN( Cs, List( Ps, p -> PathAction( re, p ) ),
                     \* ) );
end );

InstallMethod( \+, "for elements of quiver representation",
               [ IsQuiverRepresentationElement, IsQuiverRepresentationElement ],
function( e1, e2 )
  return QuiverRepresentationElementNC( RepresentationOfElement( e1 ),
                                        ListN( ElementVectors( e1 ),
                                               ElementVectors( e2 ),
                                               \+ ) );
end );

InstallMethod( AdditiveInverse, "for element of quiver representation",
               [ IsQuiverRepresentationElement ],
function( e )
  return QuiverRepresentationElementNC
         ( RepresentationOfElement( e ),
           List( ElementVectors( e ), AdditiveInverse ) );
end );

InstallMethod( \*, "for multiplicative element and element of quiver representation",
               [ IsMultiplicativeElement, IsQuiverRepresentationElement ],
function( c, e )
  local R;
  R := RepresentationOfElement( e );
  if c in FieldOfRepresentation( R ) then
    return QuiverRepresentationElementNC( R,
                                          List( ElementVectors( e ), v -> c * v ) );
  else
    TryNextMethod();
  fi;
end );

InstallMethod( \*, "for element of quiver representation and multiplicative element",
               [ IsQuiverRepresentationElement, IsMultiplicativeElement ],
function( e, c )
  local R;
  R := RepresentationOfElement( e );
  if c in FieldOfRepresentation( R ) then
    return c * e;
  else
    TryNextMethod();
  fi;
end );

# TODO module structure


DeclareRepresentation( "IsQuiverRepresentationRep", IsComponentObjectRep,
                       [ "algebra", "dimensions", "matrices" ] );

# TODO: problem with dimension zero in some vertices

InstallMethod( QuiverRepresentation, "for path algebra and dense lists",
               [ IsPathAlgebra, IsDenseList, IsDenseList ],
function( A, dimensions, matrices )
  local Q, numVertices, i, arrows, numArrows, elementFam, repFam, repType, R,
        arrow, dim_src, dim_tgt, expected_dim, matrix_dim;

  dimensions := Immutable( dimensions );
  matrices := Immutable( matrices );
  
  Q := QuiverOfAlgebra( A );
  numVertices := Length( Vertices( Q ) );
  arrows := Arrows( Q );
  numArrows := Length( Arrows( Q ) );

  if Length( dimensions ) <> numVertices then
    Error( "Wrong number of dimensions in QuiverRepresentation constructor ",
           "(", Length( dimensions ), " given, expected ", numVertices, ")" );
  fi;
  for i in [ 1 .. numVertices ] do
    if not dimensions[ i ] in NonnegativeIntegers then
      Error( "Dimension ", i, " in QuiverRepresentation constructor ",
             "is not a nonnegative integer: ", dimensions[ i ] );
    fi;
  od;
  if Length( matrices ) <> numArrows then
    Error( "Wrong number of matrices in QuiverRepresentation constructor ",
           "(", Length( matrices ), " given, expected ", numArrows, ")" );
  fi;
  for i in [ 1 .. numArrows ] do
    if not IsMatrix( matrices[ i ] ) then
      Error( "Not a matrix: ", matrices[ i ] );
    fi;
    arrow := arrows[ i ];
    dim_src := Maximum( 1, dimensions[ VertexNumber( Source( arrow ) ) ] );
    dim_tgt := Maximum( 1, dimensions[ VertexNumber( Target( arrow ) ) ] );
    if IsLeftQuiver( Q ) then
      expected_dim := [ dim_tgt, dim_src ];
    else
      expected_dim := [ dim_src, dim_tgt ];
    fi;
    matrix_dim := DimensionsMat( matrices[ i ] );
    if matrix_dim <> expected_dim then
      Error( "Wrong dimensions of matrix for arrow ", arrow,
             " (dimensions are ", matrix_dim, ", should be ", expected_dim, ")" );
    fi;
  od;
  return QuiverRepresentationNC( A, dimensions, matrices );
end );

InstallMethod( QuiverRepresentationNC, "for quiver algebra and dense lists",
               [ IsQuiverAlgebra, IsDenseList, IsDenseList ],
function( A, dimensions, matrices )
  local Q, elementFam, repFam, repType, R;
  Q := QuiverOfAlgebra( A );
  # TODO: representation should have its own elements family
  elementFam := ElementsFamily( FamilyObj( Q ) );
  repFam := CollectionsFamily( elementFam );
  repType := NewType( repFam, IsQuiverRepresentation and IsQuiverRepresentationRep );
  R := Objectify( repType, rec( algebra := A,
                                dimensions := dimensions,
                                matrices := matrices ) );
  return R;
end );

InstallMethod( AsRepresentationOfQuotientAlgebra,
               "for quiver representation and quotient of path algebra",
               [ IsQuiverRepresentation, IsQuotientOfPathAlgebra ],
function( R, A )
  local kQ, rels, rel;
  kQ := PathAlgebra( A );
  rels := RelationsOfAlgebra( A );
  for rel in rels do
    if not IsZero( MatrixForAlgebraElement( R, rel ) ) then
      Error( "Not a well-defined representation of the algebra ", A,
             "; does not respect the relation ", rel );
    fi;
  od;
  return QuiverRepresentationNC( A, VertexDimensions( R ),
                                 MatricesOfRepresentation( R ) );
end );

InstallMethod( QuiverRepresentation, "for quotient of path algebra and dense lists",
               [ IsQuotientOfPathAlgebra, IsDenseList, IsDenseList ],
function( A, dimensions, matrices )
  local kQ, rels, kQrep, rel;
  kQ := PathAlgebra( A );
  rels := RelationsOfAlgebra( A );
  kQrep := QuiverRepresentation( kQ, dimensions, matrices );
  return AsRepresentationOfQuotientAlgebra( kQrep, A );
end );

InstallMethod( QuiverRepresentationByArrows, "for quiver algebra and dense lists",
               [ IsQuiverAlgebra, IsDenseList, IsDenseList, IsDenseList ],
function( A, dimensions, arrows, matrices )
  local field, Q, all_arrows, all_matrices, num_specified_arrows, i;
  field := LeftActingDomain( A );
  Q := QuiverOfAlgebra( A );
  all_arrows := Arrows( Q );
  all_matrices :=
    List( all_arrows,
          a ->
          NullMat( Maximum( 1, dimensions[ VertexNumber( LeftEnd( a ) ) ] ),
                   Maximum( 1, dimensions[ VertexNumber( RightEnd( a ) ) ] ),
                   field ) );
  num_specified_arrows := Length( arrows );
  if num_specified_arrows <> Length( matrices ) then
    Error( "Length of arrow list not the same as length of matrix list" );
  fi;
  for i in [ 1 .. num_specified_arrows ] do
    if DimensionsMat( matrices[ i ] ) <>
       DimensionsMat( all_matrices[ ArrowNumber( arrows[ i ] ) ] ) then
      Error( "Wrong dimensions of matrix for arrow ", arrows[ i ],
             " (dimensions are ", DimensionsMat( matrices[ i ] ),
             ", should be ",
             DimensionsMat( all_matrices[ ArrowNumber( arrows[ i ] ) ] ),
             ")" );
    fi;
    all_matrices[ ArrowNumber( arrows[ i ] ) ] := matrices[ i ];
  od;
  if IsPathAlgebra( A ) then
    return QuiverRepresentationNC( A, dimensions, all_matrices );
  else
    return QuiverRepresentation( A, dimensions, all_matrices );
  fi;
end );

InstallMethod( ZeroRepresentation, "for quiver algebra",
               [ IsQuiverAlgebra ],
function( A )
  local numVertices, field;
  numVertices := NumberOfVertices( QuiverOfAlgebra( A ) );
  field := LeftActingDomain( A );
  return QuiverRepresentationByArrows( A,
                                       List( [ 1 .. numVertices ],
                                             i -> Zero( field ) ),
                                       [], [] );
end );


InstallMethod( PrintObj, "for quiver representation",
               [ IsQuiverRepresentation ],
function( R )
  Print( "<quiver representation with dimensions ",
         VertexDimensions( R ),
         " over ",
         AlgebraOfRepresentation( R ),
         ">" );
end );

InstallMethod( String, "for quiver representation",
               [ IsQuiverRepresentation ],
function( R )
  return JoinStringsWithSeparator( VertexDimensions( R ),
                                   "," );
end );

InstallMethod( ViewObj, "for quiver representation",
               [ IsQuiverRepresentation ],
function( R )
  Print( "<", String( R ), ">" );
end );

InstallMethod( Zero, "for quiver representation",
               [ IsQuiverRepresentation ],
function( R )
  return QuiverRepresentationElementByVertices( R, [], [] );
end );

InstallMethod( AlgebraOfRepresentation, "for quiver representation",
               [ IsQuiverRepresentation and IsQuiverRepresentationRep ],
function( R )
  return R!.algebra;
end );

InstallMethod( VertexDimensions, "for quiver representation",
               [ IsQuiverRepresentation and IsQuiverRepresentationRep ],
function( R )
  return R!.dimensions;
end );

InstallMethod( VertexDimension, "for quiver representation and positive integer",
               [ IsQuiverRepresentation, IsPosInt ],
function( R, i )
  return VertexDimensions( R )[ i ];
end );

InstallMethod( VertexDimension, "for quiver representation and vertex",
               [ IsQuiverRepresentation, IsVertex ],
function( R, v )
  return VertexDimension( R, VertexNumber( v ) );
end );

InstallMethod( MatricesOfRepresentation, "for quiver representation",
               [ IsQuiverRepresentation and IsQuiverRepresentationRep ],
function( R )
  return R!.matrices;
end );

InstallMethod( MatrixForArrow, "for quiver representation and positive integer",
               [ IsQuiverRepresentation, IsPosInt ],
function( R, i )
  return MatricesOfRepresentation( R )[ i ];
end );

InstallMethod( MatrixForArrow, "for quiver representation and arrow",
               [ IsQuiverRepresentation, IsArrow ],
function( R, a )
  return MatrixForArrow( R, ArrowNumber( a ) );
end );

InstallMethod( MatrixForPath, "for quiver representation and vertex",
               [ IsQuiverRepresentation, IsVertex ],
function( R, v )
  return IdentityMat( VertexDimension( R, v ),
                      FieldOfRepresentation( R ) );
end );

InstallMethod( MatrixForPath, "for quiver representation and arrow",
               [ IsQuiverRepresentation, IsArrow ],
               MatrixForArrow );

InstallMethod( MatrixForPath, "for quiver representation and composite path",
               [ IsQuiverRepresentation, IsCompositePath ],
function( R, p )
  return Product( List( ArrowListLR( p ), a -> MatrixForArrow( R, a ) ) );
end );

InstallMethod( MatrixForAlgebraElement, "for quiver representation and uniform quiver algebra element",
               [ IsQuiverRepresentation, IsQuiverAlgebraElement and IsUniform ],
function( R, e )
  return Sum( ListN( Coefficients( e ),
                     List( Paths( e ), MatrixForPath ),
                     \* ) );
end );

InstallMethod( QuiverOfRepresentation, "for quiver representation",
               [ IsQuiverRepresentation ],
function( R )
  return QuiverOfAlgebra( AlgebraOfRepresentation( R ) );
end );

InstallMethod( FieldOfRepresentation, "for quiver representation",
               [ IsQuiverRepresentation ],
function( R )
  return LeftActingDomain( AlgebraOfRepresentation( R ) );
end );

InstallMethod( LeftActingDomain, "for quiver representation",
               [ IsQuiverRepresentation ],
               FieldOfRepresentation );

DeclareRepresentation( "IsQuiverRepresentationBasisRep", IsComponentObjectRep,
                       [ "representation", "basisVectors" ] );

InstallMethod( CanonicalBasis, "for quiver representation",
               [ IsQuiverRepresentation ],
function( R )
  local Q, field, basis, vertices, dims, i, vertexBasis, j;
  Q := QuiverOfRepresentation( R );
  field := FieldOfRepresentation( R );
  basis := [];
  vertices := Vertices( Q );
  dims := VertexDimensions( R );
  for i in [ 1 .. Length( vertices ) ] do
    vertexBasis := BasisVectors( CanonicalBasis( field ^ dims[ i ] ) );
    for j in [ 1 .. dims[ i ] ] do
      Add( basis,
           QuiverRepresentationElementByVertices
           ( R, [ vertices[ i ] ], [ vertexBasis[ j ] ] ) );
    od;
  od;
  return Objectify( NewType( FamilyObj( R ),
                             IsBasis and IsQuiverRepresentationBasisRep ),
                    rec( representation := R,
                         basisVectors := basis ) );
end );

InstallMethod( Basis, "for quiver representation",
               [ IsQuiverRepresentation ],
               CanonicalBasis );

InstallMethod( BasisVectors, "for quiver representation basis",
               [ IsBasis and IsQuiverRepresentationBasisRep ],
function( B )
  return B!.basisVectors;
end );

InstallMethod( UnderlyingLeftModule, "for quiver representation basis",
               [ IsBasis and IsQuiverRepresentationBasisRep ],
function( B )
  return B!.representation;
end );

InstallMethod( Coefficients, "for quiver representation basis and quiver representation element",
               [ IsBasis and IsQuiverRepresentationBasisRep,
                 IsQuiverRepresentationElement ],
function( B, e )
  return Concatenation( ElementVectors( e ) );
end );

